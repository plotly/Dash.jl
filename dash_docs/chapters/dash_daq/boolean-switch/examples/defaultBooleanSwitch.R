library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqBooleanSwitch(id = "my-boolean-switch",
                   on = FALSE),
  htmlDiv(id = "boolean-switch-output")
)))
  
app$callback(
  output(id = "boolean-switch-output", property = "children"),
  params = list(input(id = "my-boolean-switch", property = "on")),
  
  update_booleanswitch <- function(on) {
    return (sprintf("The switch is %s.", on))
  }
)

app$run_server()
