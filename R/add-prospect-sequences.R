#' Add prospect to a sequence
#' 
#' @description Adds a prospect to a sequence given a prospect ID and a sequence ID.
#' @param prospect_id The numeric ID for an Outreach prospect.
#' @param sequence_id The numeric ID for an Outreach sequence. 
#' 
#' @importFrom httr POST add_headers verbose stop_for_status content
#' @importFrom jsonlite fromJSON
#' @export
#
add_prospect_seq <- function(prospect_id, sequence_id, mailbox_id) {
  add_prosp <- POST(
    "https://api.outreach.io/api/v2/sequenceStates",
    add_headers(`Authorization` = paste0(
      "Bearer ",
      Sys.getenv("OUTREACH_TOKEN")
    )),
    verbose(),
    body = list(data = list(
      type = "sequenceState",
      relationships = list(
        prospect = list(data = list(type = "prospect", id = prospect_id)),
        sequence = list(data = list(type = "sequence", id = sequence_id)),
        mailbox = list(data = list(type = "mailbox", id = mailbox_id))
      )
    )),
    encode = "json"
  )
  
  
  jsonlite::fromJSON(content(add_prosp, as = "text"))
}


  