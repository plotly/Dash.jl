library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

tabs_styles = list(
  'height'= '44px'
)
tab_style = list(
  'borderBottom'= '1px solid #d6d6d6',
  'padding'= '6px',
  'fontWeight'= 'bold'
)

tab_selected_style = list(
  'borderTop'= '1px solid #d6d6d6',
  'borderBottom'= '1px solid #d6d6d6',
  'backgroundColor'= '#119DFF',
  'color'= 'white',
  'padding'= '6px'
)

app$layout(htmlDiv(list(
  dccTabs(id="tabs-styled-with-inline", value='tab-1', children=list(
    dccTab(label='Tab 1', value='tab-1', style=tab_style, selected_style=tab_selected_style),
    dccTab(label='Tab 2', value='tab-2', style=tab_style, selected_style=tab_selected_style),
    dccTab(label='Tab 3', value='tab-3', style=tab_style, selected_style=tab_selected_style),
    dccTab(label='Tab 4', value='tab-4', style=tab_style, selected_style=tab_selected_style)
    ), style=tabs_styles),
  htmlDiv(id='tabs-content-inline')
  )))

app$callback(
  output = list(id='tabs-content-inline', property = 'children'),
  params = list(input(id = 'tabs-styled-with-inline', property = 'value')),
  function(tab){
    if(tab == 'tab-1'){
      return(htmlDiv(
        list(htmlH3('Tab content 1'))
      ))
    } else if(tab == 'tab-2'){
      return(htmlDiv(
        list(htmlH3('Tab content 2'))
      ))
    } else if(tab == 'tab-3'){
      return(htmlDiv(
        list(htmlH3('Tab content 3'))
      ))
    } else if(tab == 'tab-4'){
      return(htmlDiv(
        list(htmlH3('Tab content 4'))
      ))
    }
  }
)

app$run_server()

