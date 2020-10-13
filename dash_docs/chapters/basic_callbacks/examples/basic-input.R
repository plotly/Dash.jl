library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccInput(id = 'input-1', type = 'text', value = 'Montreal'),
      dccInput(id = 'input-2', type = 'text', value = 'Canada'),
      htmlDiv(id = 'output_keywords')
    )
  )
)


app$callback(output(id = 'output_keywords', property = 'children'),
             list(input(id = 'input-1', property = 'value'),
                  input(id = 'input-2', property = 'value')),
             function(input1, input2) {
               sprintf("Input 1 is \"%s\" and Input 2 is \"%s\"", input1, input2)
             })

app$run_server()
