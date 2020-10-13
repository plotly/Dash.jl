library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccInput(id='input-1-keypress', type='text', value='Montreal'),
      dccInput(id='input-2-keypress', type='text', value='Canada'),
      htmlDiv(id='output-keypress1')
    )
  )
)

app$callback(
  output(id = 'output-keypress1', property='children'),
  params=list(input(id='input-1-keypress', property='value'),
              input(id='input-2-keypress', property='value')),
  function(input1, input2) {
    sprintf('Input 1 is %s and input 2 is %s', input1,input2)
  })

app$run_server()
