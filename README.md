
<!-- README.md is generated from README.Rmd. Please edit that file -->

# outReach

<!-- badges: start -->

<!-- badges: end -->

outReach provides an R interface to the Outreach.io API. The primary
inspiration for this package is to provide a way to add existing
prospects to sequences from R. This functionality enables the creative
combination and use of a CRM data warehouse and Outreach.io. As such,
one can utilize the functionality and creativity enabled by R.

outReach can be installed from Github with
`remotes::install_github("josiahparry/outReach")`

## Authentication

Outreach.io utilizes OAuth2. Currently, `outReach` does not support
non-interactive authentication. Authentication is completed with the
`outreach_auth()` function. There are four arguments:

  - `key`: The application or client ID provided to you by Outreach.io.
  - `secret`: The secret provided by Outreach.io.
  - `redirect`: The callback URI or URL provided by Outreach.io.
  - `scopes`: A character scalar containing the API privileges to be
    granted. Each scope is to be separated by a space. Each scope is to
    be defined by the name of the resource and the access level,
    e.g. `"prospects.read sequenceStates.all"`.

Since `outreach_auth()` does not currently support non-interactive
authenticating. As such, you will be prompted to enter a code which will
exist in the code parameter of the redirected URL. Once the code is
successfully entered the authentication will complete and the two
environment variables `OUTREACH_TOKEN` and `OUTREACH_REFRESH` will be
assigned. `OUTREACH_TOKEN` expires after 120 minutes whereas
`OUTREACH_REFRESH` **does not expire**.

``` r
# Authenticate -----------------------------------
outreach_auth(key, secret, redirect, scopes)
```

The `OUTREACH_TOKEN` environment variable is provided automatically to
`outReach` functions. However, if your token expires after 120 minutes,
it can be refreshed with the `OUTREACH_REFRESH`.

``` r
# refresh token
refresh_auth_token(client, secret, redirect, refresh_token = Sys.gentenv("OUTREACH_REFRESH"))
```

## Adding prospects to sequences

To add a prospect to a sequence you need three pieces of information:

1.  Prospect ID
2.  Sequence ID
3.  Mailbox ID

Your CRM warehouse most likely contains the prospect ID. Otherwise, you
can get this information from the Outreach.io page itself. When on the
prospect overview page, the URL will look something like
`outreach.io/prospects/987/overview`. That number is the prospect’s ID.

To retrieve the sequence ID, either navigate to the sequence of interest
and find its identifier in the URL in the same manner as above or use
`get_sequences()` to create a tibble of sequencess, their descriptions,
and IDs.

The mailbox ID refers to the email address for which sequences will be
assigned. In other words, the mailbox ID is the ID of an Outreach.io
user. You can get this ID by navigating to the users page on
Outreach.io. Alternatively, you can use the `get_mailboxes()` function
to return a tibble with users’ emails, IDs, etc.

To add a prospect to a sequence, you use the `add_prospect_seq()`
function. The three argument are the prospect, sequence, and mailbox
IDs: `add_prospect_seq(prospect_id, sequence_id, mailbox_id)`.

``` r
add_prospect_seq(1, 956, 18)
```

## Searching for prospects

It is currently possible to search for your prospects using the
`search_prospects()` function. The function is currently quite limited.
`search_prospects()` allows you to query the Outreach API for prospects
(up to 1000 as of right now) based on the owner ID or email, account
name, or tag. For each of these arguments you can provide a vector of
length \> 0. If you provide, for example, a vector with two tags it will
return prospects that match at least one of the conditions. The function
returns a (rather messy) list object. In the resultant object is a list
called `data` with the element `id` that contains the prospect IDs from
the search.

## Motivating Example

The below example is some started code that demonstrates authenticating
outreach, searching for prospects based on a tag, and then adding them
all to a sequence.

``` r
remotes::install_github("josiahparry/outReach")

library(outReach)

app_id <- "your-outreach-app-id"
secret <- "your-secret"
callback <- "https://callback.com/"
safe_scopes <- "sequenceStates.read sequenceStates.write mailboxes.read prospects.read sequences.read"

# initial authentication. 
outreach_auth(app_id, secret, callback, safe_scopes)

# search for prospects with the awesome-prospects tag
prospects <- search_prospects(tag = "awesome-prospects")

# iterate over all of the prospects and add them to a sequence
purrr::map(
  .x = prospects$data$id,
  ~add_prospect_seq(.x, sequence_id = 1, mailbox_id = 5)
)
```

## Listing Resources

Today there are only two functions for listing resources.

  - `get_sequences()`: to list available sequences
  - `get_mailboxes()`: to list all user mailboxes.

-----

### In the future:

I am intending to add functions for all `GET` endpoints. Additionally I
will build a function to add prospects. I plan to keep this package
limited in scope in an effort to emphasize data entry through the
dedicated CRM or Outreach.io itself.
