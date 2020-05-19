
<!-- README.md is generated from README.Rmd. Please edit that file -->

# outReach

<!-- badges: start -->

<!-- badges: end -->

outReach provides an R interface to the Outreach.io API. Currently
non-interactive authentication for Outreach is not supported.

Authentication function sets environment variables `OUTREACH_TOKEN` and
`OUTREACH_REFRESH`. Outreach’s tokens do not persist for more than 120
minutes. After which point you will have to either re-authenticate or
refresh the token.

## Authentication

``` r
# Authenticate -----------------------------------
outreach_auth(client, secret, redirect, scopes)

# refresh token
refresh_token(client, secret, redirect, token = Sys.gentenv("OUTREACH_REFRESH"))
```

## Sequences

You can add prospects to sequences. This requires the ID of the
sequence, the prospect, and the mailbox (the user who will be sending
the email).

``` r
add_prospect_seq(prospect_id, sequence_id, mailbox_id)
```
