library(dash)
library(dashDaq)
library(dashHtmlComponents)
library(dashCoreComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqThermometer(
    id = 'my-thermometer',
    value = 5,
    min = 0,
    max = 10,
    style = list('margin-bottom' = '5%')
  ),
  dccSlider(
    id = 'thermometer-slider',
    value = 5,
    min = 0,
    max = 10
  )
)))
  
app$callback(
  output(id = "my-thermometer", property = "value"),
  params = list(input(id = "thermometer-slider", property = "value")),
  
  update_output <- function(value) {
    return(value)
  }
)

app$run_server()
