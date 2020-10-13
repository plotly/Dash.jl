library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashCytoscape)
library(stringr)

app <- Dash$new()

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
  ),
  list(
    'selector' = 'edge',
    'style' = list(
      'line-color' = '#A3C4BC'
    )
  )
)

app$layout(
  htmlDiv(
    list(
      htmlDiv(
        list(
          htmlButton(
            'Add Node', 
            id = 'btn-add-node', 
            n_clicks_timestamp = 0
          ),
          htmlButton(
            'Remove Node', 
            id = 'btn-remove-node', 
            n_clicks_timestamp = 0
          )
        )
      ),
      cytoCytoscape(
        id = 'cytoscape-update-elements',
        elements = c(edges, nodes),
        layout = list('name' = 'circle'),
        style = list('width' = '100%', 'height' = '450px'),
        stylesheet = default_stylesheet
      )
    )
  )
)

app$callback(
  output = list(id = 'cytoscape-update-elements', property = 'elements'),
  params = list(
    input(id = 'btn-add-node', property = 'n_clicks_timestamp'),
    input(id = 'btn-remove-node', property = 'n_clicks_timestamp'),
    state(id = 'cytoscape-update-elements', property = 'elements')
  ),
  function(btn_add, btn_remove, elements) {
    # if the add button was clicked most recently
    if (as.numeric(btn_add) > as.numeric(btn_remove)) {
      next_node_idx <- length(elements) - length(edges)
      # as long as max number of nodes is not reached, we add them to elements
      if (next_node_idx < length(nodes)) {
        return (c(edges, nodes[1:(next_node_idx+1)]))
      }
    }
    # if the remove button was clicked most recently
    else if (as.numeric(btn_remove) > as.numeric(btn_add)) {
      if (length(elements) > length(edges)) {
        return (elements[-length(elements)])
      }
    }
    # neither have been clicked yet (or fallback condition)
    return(elements)
  }
)

app$run_server()
