# Authentication ---------------------------------------------------------------
# Outreach uses OAuth 2.0


# create endpoint
outreach_ep <- oauth_endpoint(request = NULL, 
                              authorize = "authorize",
                              access = "token",
                              base_url = "https://api.outreach.io/oauth"
)


#' Authenticate an outrach application
#' 
#' @importFrom httr oauth2.0_authorize_url POST stop_for_status content oauth_app oauth_exchanger
#' @export
outreach_auth <- function(endpoint, key, secret, redirect, scopes) {
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

#' Refresh Outreach auth token
#' 
#' @importFrom httr POST stop_for_status content 
#' @export
refresh_token <- function(key = app_id, secret, redirect, 
                          refresh_token = Sys.getenv("OUTREACH_REFRESH")) {
  
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
  message("Updating Outreach environment variables")
  Sys.setenv(OUTREACH_TOKEN=token$access_token)
  Sys.setenv(OUTREACH_REFRESH=token$refresh_token)
  
  
}
