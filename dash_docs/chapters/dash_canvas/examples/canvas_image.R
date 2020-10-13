library(dash)
library(dashHtmlComponents)
library(dashCanvas)

app <- Dash$new()

filename <- 'https://upload.wikimedia.org/wikipedia/commons/e/e4/Mitochondria%2C_mammalian_lung_-_TEM_%282%29.jpg'
canvas_width <- 500

app$layout(htmlDiv(list(
  dashCanvas(
    id = 'canvas_image',
    tool = 'line',
    lineWidth = 5,
    lineColor = 'red',
    filename = filename,
    width = canvas_width
  )
)))

app$run_server()
