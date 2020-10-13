library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccSlider(
        id='my-slider',
        min=0,
        max=20,
        step=0.5,
        value=10
      ),
      htmlDiv(id='slider-output-container')
    )
  )
)

app$callback(
  output(id = 'slider-output-container', property = 'children'),
  params=list(input(id = 'my-slider', property = 'value')),
  function(value) {
    sprintf("you have selected %0.1f", value)
  })

app$run_server()

