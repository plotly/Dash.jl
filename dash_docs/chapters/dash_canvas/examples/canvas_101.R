library(dash)
library(dashHtmlComponents)
library(dashCanvas)

app <- Dash$new()

app$layout(htmlDiv(list(
  htmlH5("Press down the left mouse button and draw inside the canvas"),
  dashCanvas(id = 'canvas_101')
)))

app$run_server()
  
