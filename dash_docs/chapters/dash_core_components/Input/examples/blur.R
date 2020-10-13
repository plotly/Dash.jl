library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccInput(id='input-1-submit', type='text', value='Montreal'),
      dccInput(id='input-2-submit', type='text', value='Canada'),
      htmlDiv(id='output-keypress')
    )
  ))

app$callback(
  output(id = 'output-keypress', property='children'),
  params=list(input(id='input-1-submit', property='n_submit'),
              input(id = 'input-1-submit', property = 'n_blur'),
              input(id='input-2-submit', property='n_submit'),
              input(id = 'input-2-submit', property = 'n_blur'),
              state('input-1-submit', 'value'),
              state('input-2-submit', 'value')),
  function(ns1, nb1, ns2, nb2, input1, input2) {
    sprintf('Input 1 is %s and input 2 is %s', input1, input2)
  })

app$run_server()
