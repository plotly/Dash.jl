library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

app$layout(htmlDiv(list(
  dccUpload(htmlButton('Upload File')),
  
  htmlHr(),
  
  dccUpload(htmlA('Upload File')),
  
  htmlHr(),
  
  dccUpload(list(
    'Drag and Drop or ',
    htmlA('Select a File')
    ), style=list(
      'width'= '100%',
      'height'= '60px',
      'lineHeight'= '60px',
      'borderWidth'= '1px',
      'borderStyle'= 'dashed',
      'borderRadius'= '5px',
      'textAlign'= 'center'
    ))
  )))

app$run_server()
