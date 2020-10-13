library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

app$layout(htmlDiv(
  children=list(
    htmlH3("Edit text input to see loading state"),
    dccInput(id="input-1", value='Input triggers local spinner'),
    dccLoading(id="loading-1", children=list(htmlDiv(id="loading-output-1")), type="default"),
    htmlDiv(
      list(
        dccInput(id="input-2", value='Input triggers nested spinner'),
        dccLoading(
          id="loading-2",
          children=list(htmlDiv(list(htmlDiv(id="loading-output-2")))),
          type="circle"
        )
      )
    )
  )
))

app$callback(
  output = list(id='loading-output-1', property = 'children'),
  params = list(input(id = 'input-1', property = 'value')),
  function(value){
    Sys.sleep(1)
    return(value)
  }
)


app$callback(
  output = list(id='loading-output-2', property = 'children'),
  params = list(input(id = 'input-2', property = 'value')),
  function(value){
    Sys.sleep(1)
    return(value)
  }
)


app$run_server()
