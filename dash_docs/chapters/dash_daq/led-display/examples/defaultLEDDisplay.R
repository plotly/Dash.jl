library(dash)
library(dashDaq)
library(dashHtmlComponents)
library(dashCoreComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqLEDDisplay(id = 'my-LED-display',
           label = 'Default',
           value = 6),
  dccSlider(
    id = 'my-LED-display-slider',
    min = 0,
    max = 10,
    step = 1,
    value = 5
  )
)))
  
app$callback(
  output(id = "my-LED-display", property = "value"),
  params = list(input(id = "my-LED-display-slider", property = "value")),
  
  update_output <- function(value) {
    return((value))
  }
)

app$run_server()
