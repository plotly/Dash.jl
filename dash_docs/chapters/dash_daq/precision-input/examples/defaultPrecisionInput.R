library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqPrecisionInput(id = 'my-precision',
                    label = 'Default',
                    precision = 4,
                    value = 1234),
  htmlDiv(id = 'precision-output')
)))
  
app$callback(
  output(id = "precision-output", property = "children"),
  params = list(input(id = "my-precision", property = "value")),
  
  update_output <- function(value) {
    return(sprintf("The current value is %s", value))
  }
)

app$run_server()
