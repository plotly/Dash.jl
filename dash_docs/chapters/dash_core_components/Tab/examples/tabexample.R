library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  button = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Button/examples/button.R'),
  tabs = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Tabs/examples/tabs.R')
)

app <- Dash$new()

app$layout(htmlDiv(list(
  htmlH1('Dash Tabs component demo'),
  dccTabs(id="tabs-example", value='tab-1-example', children=list(
    dccTab(label='Tab One', value='tab-1-example'),
    dccTab(label='Tab Two', value='tab-2-example')
  )),
  htmlDiv(id='tabs-content-example')
)))

app$callback(
  output = list(id='tabs-content-example', property = 'children'),
  params = list(input(id = 'tabs-example', property = 'value')),
  function(tab){
    if(tab == 'tab-1-example'){
      return(htmlDiv(list(
        htmlH3('Tab content 1'),
        dccGraph(
          id='graph-1-tabs',
          figure=list(
            'data' = list(list(
              'x' = c(1, 2, 3),
              'y' = c(3, 1, 2),
              'type' = 'bar'
            ))
          )
        )
      )))
    }
    
    else if(tab == 'tab-2-example'){
      return(htmlDiv(list(
        htmlH3('Tab content 2'),
        dccGraph(
          id='graph-2-tabs',
          figure=list(
            'data' = list(list(
              'x' = c(1, 2, 3),
              'y' = c(5, 10, 6),
              'type' = 'bar'
            ))
          )
        )
      )))
    }
  }
  
  
  
)

app$run_server()
