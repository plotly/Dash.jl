library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

app$layout(htmlDiv(list(
  dccConfirmDialogProvider(
    children=htmlButton(
      'Click Me'
    ),
    id='danger-danger-provider',
    message='Danger danger! Are you sure you want to continue?'
  ),
  htmlDiv(id='output-provider')
)))

app$callback(
  output = list(id = 'output-provider', property = 'children'),
  params=list(input(id = 'danger-danger-provider', property = 'submit_n_clicks')),
  function(submit_n_clicks){
    if(is.null(submit_n_clicks) == TRUE){
      return('')
    } else{
      sprintf('It was dangerous but we did it!
              Submitted %g', submit_n_clicks)
    }
    }
  
)
