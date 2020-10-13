library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  htmlButton('Click here to see the content', id='show-secret'),
  htmlDiv(id='body-div')
)))

app$callback(
  output(id='body-div', property='children'),
  params = list(
    input(id='show-secret', property='n_clicks')
  ),
  update_output <- function(n_clicks) {
    if (is.null(n_clicks[[1]])) {
      return(dashNoUpdate())
    }
    else {
      return("Elephants are the only animal that can't jump")
    }
  }
)

app$run_server()