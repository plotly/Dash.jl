library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashCytoscape)
library(jsonlite)

app <- Dash$new()

styles <- list(
  'pre' = list(
    'border' = 'thin lightgrey solid',
    'overflowX' = 'scroll'
  )
)

nodes <- lapply(
  list(
    list('la', 'Los Angeles', 34.03, -118.25),
    list('nyc', 'New York', 40.71, -74),
    list('to', 'Toronto', 43.65, -79.38),
    list('mtl', 'Montreal', 45.50, -73.57),
    list('van', 'Vancouver', 49.28, -123.12),
    list('chi', 'Chicago', 41.88, -87.63),
    list('bos', 'Boston', 42.36, -71.06),
    list('hou', 'Houston', 29.76, -95.37)
  ),
  function (x) {
    names(x) <- c('short', 'label', 'long', 'lat')
    return(
      list(
        data = list('id' = x$short, 'label' = x$label),
        position = list('x' = 20*x$lat, 'y' = -20*x$long)
      )
    )
  }
)

edges <- lapply(
  list(
    list('van', 'la'),
    list('la', 'chi'),
    list('hou', 'chi'),
    list('to', 'mtl'),
    list('mtl', 'bos'),
    list('nyc', 'boston'),
    list('to', 'hou'),
    list('to', 'nyc'),
    list('la', 'nyc'),
    list('nyc', 'bos')
  ),
  function (x) {
    names(x) <- c('source', 'target')
    return(
      list(
        data = list('source' = x$source, 'target' = x$target)
      )
    )
  }
)

default_stylesheet <- list(
  list(
    'selector' = 'node',
    'style' = list(
      'background-color' = '#BFD7B5',
      'label' = 'data(label)'
    )
  )
)

app$layout(
  htmlDiv(
    list(
      cytoCytoscape(
        id = 'cytoscape-event-callbacks-1',
        elements = c(edges, nodes),
        layout = list('name' = 'preset'),
        style = list('width' = '100%', 'height' = '450px'),
        stylesheet = default_stylesheet
      ),
      htmlPre(
        id = 'cytoscape-tapNodeData-json',
        style = styles[['pre']]
      )
    )
  )
)

app$callback(
  output = list(id = 'cytoscape-tapNodeData-json', property = 'children'),
  params = list(
    input(id = 'cytoscape-event-callbacks-1', property = 'tapNodeData')
  ),
  function(data) {
    return(
      toJSON(data, pretty = TRUE, null = 'null')
    )
  }
)

app$run_server()
