#' Search Outreach.io prospects.
#' 
#' 
#' @param owner_email Prospect owner email address(es). Optional. 
#' @param owner_id Prospect owner ID(s) (also known as mailbox ID). Optional.
#' @param account_name Account name(s). Optional.
#' @param tag Prospect tag(s). Optional.
#' @param token Your Outreach.io token which should be stored in the environment variable \code{OUTEREACH_TOKEN} if authentication was done with \code{outreach_auth()}
#' 
#' @importFrom httr GET add_headers
#' @importFrom purrr map2
#' 
#' @export
#' 

search_prospects <- function(owner_email, owner_id, account_name, tag,
                            token = Sys.getenv("OUTREACH_TOKEN")) {

  missing_args <- c(missing(owner_email), missing(owner_id), missing(account_name), missing(tag))
  
  filter_names <- list(
    c("owner", "email"),
    c("owner", "id"),
    c("account", "name"),
    "tags"
       )
  
  filter_vals <- list("owner_email", "owner_id", "account_name", "tag")
  
  all_filters <- paste(purrr::map2(
    filter_names[!missing_args], 
    filter_vals[!missing_args], 
    ~prep_filters(.x, get(.y))
    ),
    collapse = "&")
  
  base_url <- "https://api.outreach.io/api/v2/prospects?page[limit]=1000&"
  
  q <- httr::GET(URLencode(paste(base_url, all_filters, sep = "", collapse = "")),
            add_headers(`Authorization` = paste0("Bearer ", token)))
  
  parse_outreach(q)
  
}
