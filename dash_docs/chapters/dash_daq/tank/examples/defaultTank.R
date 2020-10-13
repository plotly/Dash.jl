library(dash)
library(dashDaq)
library(dashHtmlComponents)
library(dashCoreComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqTank(
    id = 'my-tank',
    value = 5,
    min = 0,
    max = 10,
    style = list('margin-left' = '50px')
  ),
  dccSlider(
    id = 'tank-slider',
    value = 5,
    min = 0,
    max = 10
  )
)))
  
app$callback(
  output(id = "my-tank", property = "value"),
  params = list(input(id = "tank-slider", property = "value")),
  
  update_output <- function(value) {
    return(value)
  }
)

app$run_server()
