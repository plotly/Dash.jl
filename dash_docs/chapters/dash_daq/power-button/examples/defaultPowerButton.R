library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqPowerButton(id = 'my-power-button',
                 on = FALSE),
  htmlDiv(id = 'power-button-output')
)))
  
app$callback(
  output(id = "power-button-output", property = "children"),
  params = list(input(id = "my-power-button", property = "on")),
  
  update_output <- function(on) {
    return(sprintf("The button is %s", on))
  }
)

app$run_server()
