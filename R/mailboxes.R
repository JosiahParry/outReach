
get_mailboxes <- function() {
  
  mb <- GET("https://api.outreach.io/api/v2/mailboxes",
            add_headers(`Authorization` = paste0("Bearer ", Sys.getenv("OUTREACH_TOKEN"))),
            verbose()) 
  
  
  res <- jsonlite::fromJSON(content(mb, as = "text"))
  
  tibble(res$data$attributes %>% 
           janitor::clean_names()) %>% 
    select(user_id, email, email_signature, everything())
  
}

