library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  dccTabs(id="tabs", value='tab-1', children=list(
    dccTab(label='Tab one', value='tab-1'),
    dccTab(label='Tab two', value='tab-2')
    )),
  htmlDiv(id='tabs-content')
  )))

app$callback(output('tabs-content', 'children'),
    params = list(input('tabs', 'value')),
function(tab){
  if(tab == 'tab-1'){
  return(htmlDiv(list(
    htmlH3('Tab content 1')
    )))}
  else if(tab == 'tab-2'){
  return(htmlDiv(list(
    htmlH3('Tab content 2')
    )))}
}
)

app$run_server()
