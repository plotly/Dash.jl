library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqToggleSwitch(id = 'my-toggle-switch',
                value = FALSE),
  htmlDiv(id = 'toggle-switch-output')
)))
  
app$callback(
  output(id = "toggle-switch-output", property = "children"),
  params = list(input(id = "my-toggle-switch", property = "value")),
  
  update_output <- function(value) {
    return(sprintf("The switch is %s.", value))
  }
)

app$run_server()
