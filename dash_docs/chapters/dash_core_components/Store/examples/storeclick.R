library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

app$layout(htmlDiv(list(
  # The memory store reverts to the default on every page refresh
  dccStore(id='memory'),
  # The local store will take the initial data
  # only the first time the page is loaded
  # and keep it until it is cleared.
  dccStore(id='local', storage_type='local'),
  # Same as the local store but will lose the data
  # when the browser/tab closes.
  dccStore(id='session', storage_type='session'),
  htmlTable(list(
    htmlThead(list(
      htmlTr(htmlTh('Click to store in:', colSpan='3')),
      htmlTr(list(
        htmlTh(htmlButton('memory', id='memory-button')),
        htmlTh(htmlButton('localStorage', id='local-button')),
        htmlTh(htmlButton('sessionStorage', id='session-button'))
      )),
      htmlTr(list(
        htmlTh('Memory clicks'),
        htmlTh('Local clicks'),
        htmlTh('Session clicks')
      ))
    )),
    htmlTbody(list(
      htmlTr(list(
        htmlTd(0, id='memory-clicks'),
        htmlTd(0, id='local-clicks'),
        htmlTd(0, id='session-clicks')
      ))
    ))
  ))
)))

for (i in c('memory', 'local', 'session')) {
  app$callback(
    output(id = i, property = 'data'),
    params = list(
      input(id = sprintf('%s-button', i), property = 'n_clicks'),
      state(id = i, property = 'data')
    ),
    function(n_clicks, data){
      if(is.null(n_clicks)){
        return()
      }
      
      if(is.null(data[[1]])){
        data = list('clicks' = 0)
      } else{
        data = data
      }  
      data['clicks'] = data$clicks + 1
      return(data)
    }
  )
}

for (i in c('memory', 'local', 'session')) {
  app$callback(
    output(id = sprintf('%s-clicks', i), property = 'children'),
    params = list(
      input(id = i, property = 'modified_timestamp'),
      state(id = i, property = 'data')
    ),
    function(ts, data){
      if(is.null(ts)){
        return()
      }
      if(is.null(data[[1]])){
        data = list()
      } else{
        data = data
      }  
      return(data$clicks[[1]])
    }
  )
}

app$run_server()
