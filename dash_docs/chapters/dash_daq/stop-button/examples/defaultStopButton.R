library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqStopButton(
    id = 'my-stop-button',
    label = 'Default',
    n_clicks = 0
  ),
  htmlDiv(id = 'stop-button-output')
)))
  
app$callback(
  output(id = "stop-button-output", property = "children"),
  params = list(input(id = "my-stop-button", property = "n_clicks")),
  
  update_output <- function(n_clicks) {
    return(sprintf("The stop button has been clicked %s times.", n_clicks))
  }
)

app$run_server()
