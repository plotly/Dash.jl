# library(dash)
# library(dashCoreComponents)
# library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
    dccInput(id='input-1', type='text', value='Montréal'),
    dccInput(id='input-2', type='text', value='Canada'),
    htmlDiv(id='output')
)))


app$callback(output('output', 'children'),
            list(input('input-1', 'value'),
                 input('input-2', 'value')),
            function(input1, input2) {
  sprintf("Input 1 is \"%s\" and Input 2 is \"%s\"", input1, input2)
})

app$run_heroku()
