#' Get Outreach Sequence Information
#' 
#' Returns a tibble containing sequence ID, attributes, and relationships. The sequence ID is used to add prospects to sequences using \code{add_prospect_seq()}. 
#'
#' @inheritParams get_mailboxes
#'
#' @importFrom httr GET add_headers content
#' @importFrom jsonlite fromJSON
#' @importFrom janitor clean_names
#' @importFrom tibble tibble
#' @importFrom dplyr bind_cols select 
#' @importFrom tidyselect everything
#' @return A tibble containing sequence identifiers and associated information.
#' @export
#'
get_sequences <- function(token = Sys.getenv("OUTREACH_TOKEN")) {
  
  # get the first 999 sequences
  seqs <- GET("https://api.outreach.io/api/v2/sequences?page[limit]=999",
              add_headers(`Authorization` = paste0("Bearer ", token)))

  # parse results
  res <- jsonlite::fromJSON(content(seqs, as = "text"))
  
  # pluck the attributes
  res_att <- janitor::clean_names(res$data$attributes)
  
  # pluck the relationships
  res_rel <- jsonlite::flatten(res$data$relationships) %>% 
    janitor::clean_names()
  
  # put it together in a nice tibble
  clean_seqs <- tibble(
    seq_id = res$data$id
  ) %>% 
    bind_cols(
      seq_attributes = res_att,
      seq_relationships = res_rel
    ) %>% 
    select(seq_id, name, description, automation_percentage, everything())
  
}

 










