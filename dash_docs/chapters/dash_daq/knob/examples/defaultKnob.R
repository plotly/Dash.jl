library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqKnob(id = 'my-knob'),
  htmlDiv(id = 'knob-output')
)))
  
app$callback(
  output(id = "knob-output", property = "children"),
  params = list(input(id = "my-knob", property = "value")),
  
  update_output <- function(value) {
    return(sprintf('The knob value is %s', value))
  }
)

app$run_server()
