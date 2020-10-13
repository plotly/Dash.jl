library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(jsonlite)


app <- Dash$new()

styles = list(
  pre = list(
    border = 'thin lightgrey solid',
    overflowX = 'scroll'
  )
)

app$layout(
  htmlDiv(list(
    dccGraph(
      id = 'basic-interactions',
      figure = list(
        data = list(
          list(
            x = c(1, 2, 3, 4),
            y = c(4, 1, 3, 5),
            text = c('a', 'b', 'c', 'd'),
            customdata = c('c.a', 'c.b', 'c.c', 'c.d'),
            name = 'Trace 1',
            mode = 'markers',
            marker = list(size = 12)
          ),
          list(
            x = c(1, 2, 3, 4),
            y = c(9, 4, 1, 4),
            text = c('w', 'x', 'y', 'z'),
            customdata = c('c.w', 'c.x', 'c.y', 'c.z'),
            name = 'Trace 2',
            mode = 'markers',
            marker = list(size = 12)
          )
        ),
        layout = list(
          clickmode = 'event+select'
        )
      )
    ),
    
    htmlDiv(
      className = 'row',
      children = list(
        
        htmlDiv(
          list(
            dccMarkdown(
              "
              **Hover Data**
              Mouse over values in the graph.
              "
            ), htmlPre(id='hover-data', style=styles$pre)
          ), className='three columns'
        ),
        
        htmlDiv(
          list(
            dccMarkdown(
              "
              **Click Data**
              Click on points in the graph.
              "
            ), htmlPre(id='click-data', style=styles$pre)
          ), className='three columns'
        ),
        
        htmlDiv(list(
          dccMarkdown("
                      **Selection Data**
                      Choose the lasso or rectangle tool in the graph's menu
                      bar and then select points in the graph.
                      Selection data also accumulates (or un-accumulates) selected
                      data if you hold down the shift button while clicking.
                      "), htmlPre(id='selected-data', style=styles$pre)
        ), className='three columns'
        ),
        
        htmlDiv(list(
          dccMarkdown("
                      **Zoom and Relayout Data**
                      Click and drag on the graph to zoom or click on the zoom
                      buttons in the graph's menu bar.
                      Clicking on legend items will also fire
                      this event.
                      "), htmlPre(id='relayout-data', style=styles$pre)
        ), className='three columns'
        )
      )
    )
  ))
)

app$callback(output = list(id = 'hover-data', property = 'children'),
             params = list(input(id = 'basic-interactions', property = 'hoverData')),
             function(hoverData) {
               return(prettify(toJSON(hoverData),indent = 2))
             })


app$callback(output = list(id = 'click-data', property = 'children'),
             params = list(input(id = 'basic-interactions', property = 'clickData')),
             function(clickData) {
               return(prettify(toJSON(clickData),indent = 2))
             })

app$callback(output = list(id = 'selected-data', property = 'children'),
             params = list(input(id = 'basic-interactions', property = 'selectedData')),
             function(selectedData) {
               return(prettify(toJSON(selectedData),indent = 2))
             })

app$callback(output = list(id = 'relayout-data', property = 'children'),
             params = list(input(id = 'basic-interactions', property = 'relayoutData')),
             function(relayoutData) {
               return(prettify(toJSON(relayoutData),indent = 2))
             })

app$run_server()
