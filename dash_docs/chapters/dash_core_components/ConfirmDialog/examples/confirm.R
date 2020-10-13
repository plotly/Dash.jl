library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccConfirmDialog(
        id='confirm',
        message='Danger danger! Are you sure you want to continue?'
      ),
      
      dccDropdown(
        options=lapply(list('Safe', 'Danger!!'),function(x){list('label'= x, 'value'= x)}),
        id='dropdown'
      ),
      htmlDiv(id='output-confirm1')
    )
  )
)

app$callback(
  output = list(id = 'confirm', property = 'displayed'),
  params=list(input(id = 'dropdown', property = 'value')),
  function(value){
    if(value == 'Danger!!'){
      return(TRUE)}
    else{
      return(FALSE)}
  })


app$callback(
  output = list(id = 'output-confirm1', property = 'children'),
  params=list(input(id = 'confirm', property = 'submit_n_clicks')),
  function(n_clicks, value) {
    if(length(submit_n_clicks) == FALSE){
      sprintf('It wasnt easy but we did it %s', str(submit_n_clicks))
    }
  })

app$run_server()


