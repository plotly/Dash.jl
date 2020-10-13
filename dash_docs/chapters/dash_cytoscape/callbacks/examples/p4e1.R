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

elements <- c(nodes, edges)

app$layout(
  htmlDiv(
    list(
      dccDropdown(
        id = 'dropdown-update-layout',
        value = 'grid',
        clearable = FALSE,
        options = lapply(
          list('grid', 'random', 'circle', 'cose', 'concentric'),
          function(name) {
            return(
              list('label' = str_to_title(name), 'value' = name)
            )
          }
        )
      ),
      cytoCytoscape(
        id = 'cytoscape-update-layout',
        elements = elements,
        layout = list('name' = 'grid'),
        style = list('width' = '100%', 'height' = '400px')
      )
    )
  )
)

app$callback(
  output = list(id = 'cytoscape-update-layout', property = 'layout'),
  params = list(
    input(id = 'dropdown-update-layout', property = 'value')
  ),
  function(layout) {
    return(
      list(
        'name' = layout,
        'animate' = TRUE
      )
    )
  }
)

app$run_server()
