library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

app$layout(htmlDiv(list(
  dccTabs(
    id="tabs-with-classes",
    value='tab-2',
    parent_className='custom-tabs',
    className='custom-tabs-container',
    children=list(
      dccTab(
        label='Tab one',
        value='tab-1',
        className='custom-tab',
        selected_className='custom-tab--selected'
      ),
      dccTab(
        label='Tab two',
        value='tab-2',
        className='custom-tab',
        selected_className='custom-tab--selected'
      ),
      dccTab(
        label='Tab three, multiline',
        value='tab-3', className='custom-tab',
        selected_className='custom-tab--selected'
      ),
      dccTab(
        label='Tab four',
        value='tab-4',
        className='custom-tab',
        selected_className='custom-tab--selected'
      )
      )),
  htmlDiv(id='tabs-content-classes')
  )))

app$callback(
  output = list(id='tabs-content-classes', property = 'children'),
  params = list(input(id = 'tabs-with-classes', property = 'value')),
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






