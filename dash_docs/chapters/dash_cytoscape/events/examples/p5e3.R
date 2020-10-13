library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashCytoscape)

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
        id = 'cytoscape-event-callbacks-3',
        layout = list('name' = 'preset'),
        elements = c(edges, nodes),
        stylesheet = default_stylesheet,
        style = list('width' = '100%', 'height' = '450px')
      ),
      dccMarkdown(id = 'cytoscape-selectedNodeData-markdown')
    )
  )
)

app$callback(
  output = list(id = 'cytoscape-selectedNodeData-markdown', property = 'children'),
  params = list(
    input(id = 'cytoscape-event-callbacks-3', property = 'selectedNodeData')
  ),
  function(data_list) {
    if (length(data_list) == 0) {
      return("No city selected.")
    } else if (is.null(data_list[[1]])) {
      return("No city selected.")
    } else {
      cities_list <- lapply(data_list, function(data) {return(data[['label']])})
      return(
        sprintf("You selected the following cities: \n %s", paste(cities_list, collapse = ", "))
      )
    }
  }
)

app$run_server()
