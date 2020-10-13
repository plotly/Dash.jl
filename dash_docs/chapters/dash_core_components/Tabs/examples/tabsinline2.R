library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

app$layout(htmlDiv(list(
  dccTabs(id="tabs-styled-with-props", value='tab-1', children=list(
    dccTab(label='1', value='tab-1'),
    dccTab(label='2', value='tab-2')
    ), colors=list(
      "border"= "white",
      "primary"= "gold",
      "background"= "cornsilk"
    )),
  htmlDiv(id='tabs-content-props')
  )))

app$callback(
  output = list(id='tabs-content-props', property = 'children'),
  params = list(input(id = 'tabs-styled-with-props', property = 'value')),
  function(tab){
    if(tab == 'tab-1'){
      return(htmlDiv(
        list(htmlH3('Tab content 1'))
      ))
    } else if(tab == 'tab-2'){
      return(htmlDiv(
        list(htmlH3('Tab content 2'))
      ))
    }
  })

app$run_server()
