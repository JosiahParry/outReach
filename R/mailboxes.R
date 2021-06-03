#' Get Outreach Mailboxes
#' 
#' \code{get_mailboxes()} returns mailbox information for Outreach users. The "mailbox" is a reference to the user and user email address from which sequences and emails will be sent from or associated with. The mailbox identifier is referred to as the \code{user_id} in the Outreach API. 
#'
#' @return A tibble containing Outreach users and their respective email address, signatures, and \code{user_id}—a.k.a. their mailbox ID.
#' 
#' @param token Your Outreach.io token which should be stored in the environment variable \code{OUTEREACH_TOKEN} if authentication was done with \code{outreach_auth()}
#' 
#' @export
#' @importFrom httr GET add_headers content
#' @importFrom jsonlite fromJSON 
#' @importFrom tibble tibble
#' @importFrom dplyr select bind_rows
#' @importFrom janitor clean_names
#' @importFrom purrr map map_dfr
#' @examples
#' 
#' \dontrun{
#' all_mailboxes <- get_mailboxes()
#' }
#' 
get_mailboxes <- function(token = Sys.getenv("OUTREACH_TOKEN")) {
  
  mb <- GET("https://api.outreach.io/api/v2/mailboxes",
            add_headers(`Authorization` = paste0("Bearer ", token))) 
  
  res <- jsonlite::fromJSON(content(mb, as = "text"))
  
  n_pages <- ceiling(res$meta$count/50)
  
  init_res <- tidy_mb(res)
  
  if (n_pages > 1) {
    query_urls <- glue::glue("https://api.outreach.io/api/v2/mailboxes?page%5Boffset%5D={1:(n_pages-1) * 50}")  
    pages <- purrr::map(query_urls, ~httr::GET(.x, add_headers(`Authorization` = paste0("Bearer ", token)), encode = "json"))
    
    new_res <- map(pages, ~jsonlite::fromJSON(content(.x, as = "text"))) %>% 
      map_dfr(tidy_mb)
    
    return(bind_rows(init_res, new_res))
  } 
  
  init_res
  
}

#' @importFrom tibble as_tibble
#' @importFrom dplyr select mutate
#' @keywords internal
tidy_mb <- function(res) {

  res$data$attributes %>%
    janitor::clean_names() %>% 
    as_tibble() %>% 
    mutate(mailbox_id = res$data$id) %>% 
    select(mailbox_id, user_id, email, email_signature, everything()) 
}

