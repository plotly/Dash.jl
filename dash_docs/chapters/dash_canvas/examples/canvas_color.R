library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(plotly)
library(dashDaq)
library(dashCanvas)

filename <- 'https://www.publicdomainpictures.net/pictures/60000/nahled/flower-outline-coloring-page.jpg'
canvas_width <- 300

app <- Dash$new()

app$layout(htmlDiv(list(
  htmlDiv(
    dashCanvas(
      id = 'canvas-color',
      width = canvas_width,
      filename = filename,
      hide_buttons = list('line', 'zoom', 'pan')
    ),
    className = 'six columns'
  ),
  htmlDiv(
    list(
      htmlH6(children = 'Brush width'),
      dccSlider(
        id = 'bg-width-slider',
        min = 2,
        max = 40,
        step = 1,
        value = 5
      ),
      daqColorPicker(id = 'color-picker', label = 'Brush color', value = '#119DFF')
    ), className = 'three columns')
)), className = "row")

app$callback(
  output=list(id='canvas-color', property='lineColor'),
  params=list(input(id='color-picker', property='value')),
  function(value){
    if(class(value)=='list'){
      return(value[['hex']])
    } else{
      return(value)
    }
  }
)

app$callback(
  output=list(id='canvas-color', property='lineWidth'),
  params=list(input(id='bg-width-slider', property='value')),
  function(value){
    return(value)
  }
)

app$run_server()
