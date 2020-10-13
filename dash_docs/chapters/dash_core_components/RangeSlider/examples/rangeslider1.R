library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccRangeSlider(
        id='my-range-slider',
        min=0,
        max=20,
        step=0.5,
        value=list(5, 15)
      ),
      htmlDiv(id='output-container-range-slider')
    )
  )
)

app$callback(
  output(id = 'output-container-range-slider', property='children'),
  params=list(input(id='my-range-slider', property='value')),
  function(value) {
    sprintf('You have selected [%0.1f, %0.1f]', value[1], value[2])
  })

app$run_server()

