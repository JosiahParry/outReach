# create endpoint
outreach_ep <- httr::oauth_endpoint(request = NULL, 
                                    authorize = "authorize",
                                    access = "token",
                                    base_url = "https://api.outreach.io/oauth")


# create string for filters
prep_filters <- function(filters = NULL, values = NULL) {
  filts <- paste("[", filters, "]", sep = "", collapse = "")
  vals <- paste(values, collapse = ",")
  
  if(is.null(filters) | is.null(values)) {
    return(NULL)
  } else {
    
    paste("filter", filts, "=", vals, collapse = "", sep = "")  
  }
}


parse_outreach <- function(resp) {
  jsonlite::fromJSON(content(resp, as = "text"))
}