library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(uuid)
library(readr)

external_stylesheets <- list(
  # Dash CSS
  'https://codepen.io/chriddyp/pen/bWLwgP.css',
  # Loading screen CSS
  'https://codepen.io/chriddyp/pen/brPBPO.css')

app <- Dash$new(external_stylesheets = external_stylesheets)

# TODO
# cache = Cache(app.server, config={
#   'CACHE_TYPE': 'redis',
#   # Note that filesystem cache doesn't work on systems with ephemeral
#   # filesystems like Heroku.
#   'CACHE_TYPE': 'filesystem',
#   'CACHE_DIR': 'cache-directory',
# 
#   # should be equal to maximum number of users on the app at a single time
#   # higher numbers will store more data in the filesystem / redis cache
#   'CACHE_THRESHOLD': 200
# })

get_dataframe <- function(session_id) {
# @cache.memoize()  
  query_and_serialize_data <- function(session_id) {
    now <- Sys.time()
    # Sys.sleep(5)
    df <- data.frame(
      time = c(
        as.character(now - 15), # 15 seconds ahead
        as.character(now - 10), # 10 seconds ahead
        as.character(now - 5), # 5 seconds ahead
        as.character(now)
      ),
      value = c("a", "b", "c", "d")
    )
    
    jsonlite::toJSON(df)
  }
  
  jsonlite::fromJSON(query_and_serialize_data(session_id))
}


app$layout(
  htmlDiv(
    list(
      htmlDiv(children = as.character(uuid::UUIDgenerate()),
              id='session-id', 
              style = list(display = "none")),
      htmlButton(children = 'Get data', id='button', n_clicks = 0),
      htmlDiv(id='output-1'),
      htmlDiv(id='output-2')
    )
  )
)

app$callback(
  output(id = 'output-1', property = 'children'),
  list(input(id = 'button', property = 'n_clicks'),
       input(id = 'session-id', property = 'children')),
  function(value, session_id) {
    df <- get_dataframe(session_id)

    htmlDiv(
      list(
        paste(c("Output 1 - Button has been clicked", value, "times"), collapse = " "),
        htmlPre(readr::format_csv(df))
      )
    )
  }
)

app$callback(
  output(id = 'output-2', property = 'children'),
  list(input(id = 'button', property = 'n_clicks'),
       input(id = 'session-id', property = 'children')
  ),
  function(value, session_id) {
    df <- get_dataframe(session_id)
    
    htmlDiv(
      list(
        htmlDiv(paste(c("Output 2 - Button has been clicked", value, "times"), collapse = " ")),
        htmlPre(readr::format_csv(df))
      )
    )
  }
)

app$run_server()
