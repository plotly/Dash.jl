library(dash)
library(dashDaq)
library(dashHtmlComponents)
library(dashCoreComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqGraduatedBar(id = 'my-graduated-bar',
           label = 'Default',
           value = 6),
  dccSlider(
    id = 'my-graduated-bar-slider',
    min = 0,
    max = 10,
    step = 1,
    value = 5
  )
)))
  
app$callback(
  output(id = "my-graduated-bar", property = "value"),
  params = list(input(id = "my-graduated-bar-slider", property = "value")),
  
  update_output <- function(value) {
    return(value)
  }
)

app$run_server()
