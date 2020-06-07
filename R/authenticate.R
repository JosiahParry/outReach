#' Authenticate an Outreach application
#' 
#' @param key The application or client ID provided to you by Outreach.io.
#' @param secret The secret provided by Outreach.io.
#' @param redirect The callback URI or URL provided by Outreach.io.
#' @param scopes A character scalar containing the API privileges to be granted. Each scope is to be separated by a space. Each scope is to be defined by the name of the resource and the access level, e.g. \code{"prospects.read sequenceStates.all"}. 
#' 
#'
#' @importFrom httr oauth2.0_authorize_url POST stop_for_status content oauth_app oauth_exchanger
#' @export
#
outreach_auth <- function(key, secret, redirect, scopes) {
  
  # create app
  outreach_app <- oauth_app("Outreach.io", key, secret, redirect)
  
  
  # Initial Auth ----------------------------------------------------------------
  tk <- oauth2.0_authorize_url(outreach_ep, outreach_app, scopes)
  
  code <- httr::oauth_exchanger(tk)
  
  
  r2 <- POST("https://api.outreach.io/oauth/token", 
             body = list(
               client_id = key,
               client_secret = secret,
               redirect_uri = redirect,
               grant_type = "authorization_code",
               code = code$code
             ))
  
  # check for errors
  stop_for_status(r2)
  
  # parse response
  token <- content(r2)
  
  # set environment variable for refresh and access
  Sys.setenv(OUTREACH_TOKEN=token$access_token)
  Sys.setenv(OUTREACH_REFRESH=token$refresh_token)
  
  token
}

#' Refresh Outreach Authentication Token
#'
#' Authentication tokens granted by the Outreach.io API last for only 120 minutes. After which period the tokens need to be refreshed using the refresh token provided alongside the grant token. 
#' 
#' @param key The application or client ID provided to you by Outreach.io.
#' @param secret The secret provided by Outreach.io.
#' @param redirect The callback URI or URL provided by Outreach.io.
#' @importFrom httr POST stop_for_status content 
#' @export
refresh_auth_token <- function(key, secret, redirect, refresh_token = Sys.getenv("OUTREACH_REFRESH")) {
  
  refresh <- POST("https://api.outreach.io/oauth/token", 
                  body = list(
                    client_id = key,
                    client_secret = secret,
                    redirect_uri = redirect,
                    grant_type = "refresh_token",
                    refresh_token = refresh_token
                  ))
  stop_for_status(refresh)
  
  # parse response
  token <- content(refresh)
  
  # set environment variable for refresh and access
  message("Updating environment variables `OUTEREACH_TOKEN` and `OUTREACH_REFRESH`")
  
  Sys.setenv(OUTREACH_TOKEN=token$access_token)
  Sys.setenv(OUTREACH_REFRESH=token$refresh_token)
  
  
}
