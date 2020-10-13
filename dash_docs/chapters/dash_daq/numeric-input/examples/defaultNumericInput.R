library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqNumericInput(id = 'my-numeric-input',
                  value = 0),
  htmlDiv(id = 'numeric-input-output')
)))
  
app$callback(
  output(id = "numeric-input-output", property = "children"),
  params = list(input(id = "my-numeric-input", property = "value")),
  
  update_output <- function(value) {
    return(sprintf("The value is %s", value))
  }
)

app$run_server()
