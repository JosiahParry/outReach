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
#' @importFrom dplyr select
#' @importFrom janitor clean_names
#'
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
  
  tibble(res$data$attributes %>% 
           janitor::clean_names()) %>% 
    select(user_id, email, email_signature, everything())
  
  
}

 