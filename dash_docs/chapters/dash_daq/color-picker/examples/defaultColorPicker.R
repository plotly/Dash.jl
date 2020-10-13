library(dash)
library(dashDaq)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  daqColorPicker(id = 'my-color-picker',
                 label = 'Color Picker',
                 value = '#119DFF'),
  htmlDiv(id = 'color-picker-output')
)))
  
app$callback(
  output(id = 'color-picker-output', property = 'children'),
  params = list(input(id = 'my-color-picker', property = 'value')),
  
  update_output <- function(value) {
    return (sprintf('The selected color is %s.', value))
  }
)

app$run_server()
