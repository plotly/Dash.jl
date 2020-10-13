library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

transform_value = function(value){
  return(10 ** value)
}

app <- Dash$new()

transform_value = function(value){
  10 ** value
}

app$layout(
  htmlDiv(
    list(
      dccRangeSlider(
        id='non-linear-range-slider',
        marks=unlist(lapply(list(1:4), function(x){10**x})),
        max=3,
        value=list(0.1, 2),
        dots=FALSE,
        step=0.01,
        updatemode='drag'
      ),
      htmlDiv(id='output-container-range-slider-non-linear', style=list('margin-top' = 20))
  )
))

app$callback(
  output(id = 'output-container-range-slider-non-linear', property='children'),
  params=list(input(id='non-linear-range-slider', property='value')),
  function(value) {
    transformed_value = lapply(value, transform_value)
    sprintf('Linear Value: %g, Log Value: [%0.2f, %0.2f]', value[2],transformed_value[1], transformed_value[2])
  })

app$run_server()
