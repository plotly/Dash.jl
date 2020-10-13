library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

transform_value = function(value){
  return(10**value)
}

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccSlider(
        id='slider-updatemode',
        marks=unlist(lapply(list(1:4), function(x){10**x})),
        max=3,
        value=2,
        step=0.01,
        updatemode='drag'
      ),
      htmlDiv(id='updatemode-output-container', style=list('margin-top' = 20))
    )
  )
)

app$callback(
  output(id = 'updatemode-output-container', property='children'),
  params=list(input(id='slider-updatemode', property='value')),
  function(value) {
    sprintf('Linear Value: %g | Log Value: %0.2f', value, transform_value(value))
  })

app$run_server()

