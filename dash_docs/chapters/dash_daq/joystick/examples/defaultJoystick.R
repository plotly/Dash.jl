library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqJoystick(id = 'my-joystick',
               label = 'Default',
               angle = 0),
  htmlDiv(id = 'joystick-output')
)))
  
app$callback(
  output(id = "joystick-output", property = "children"),
  params = list(
    input(id = "my-joystick", property = "angle"),
    input(id = "my-joystick", property = "force")
  ),

  update_output <- function(angle, force) {
    return(list(
      sprintf('Angle is %s', angle),
      htmlBr(),
      sprintf('Force is %s', force)
    ))
  }
)

app$run_server()
