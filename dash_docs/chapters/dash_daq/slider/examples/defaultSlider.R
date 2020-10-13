library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqSlider(id = 'my-daq-slider-ex',
            value = 17),
  htmlDiv(id = 'slider-output')
)))
  
app$callback(
  output(id = "slider-output", property = "children"),
  params = list(input(id = "my-daq-slider-ex", property = "value")),
  
  update_output <- function(val) {
    return(sprintf("The slider is currently at %s", val))
  }
)

app$run_server()
