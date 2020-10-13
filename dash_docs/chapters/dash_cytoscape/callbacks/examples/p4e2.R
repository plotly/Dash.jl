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
          htmlDiv(
            style = list('width' = '50%', 'display' = 'inline'), 
            children = list(
              'Edge Color:',
              dccInput(id = 'input-line-color', type = 'text')
            )
          ),
          htmlDiv(
            style = list('width' = '50%', 'display' = 'inline'), 
            children = list(
              'Node Color:',
              dccInput(id = 'input-bg-color', type = 'text')
            )
          )
        )
      ),
      cytoCytoscape(
        id = 'cytoscape-update-stylesheet',
        elements = elements,
        layout = list('name' = 'circle'),
        style = list('width' = '100%', 'height' = '450px'),
        stylesheet = default_stylesheet
      )
    )
  )
)

app$callback(
  output = list(id = 'cytoscape-update-stylesheet', property = 'stylesheet'),
  params = list(
    input(id = 'input-line-color', property = 'value'),
    input(id = 'input-bg-color', property = 'value')
  ),
  function(line_color, bg_color) {
    if (is.null(line_color[[1]])) {
      line_color <- ''
    }
    if (is.null(bg_color[[1]])) {
      bg_color <- ''
    }
    new_styles <- list(
      list(
        'selector' = 'node',
        'style' = list(
          'background-color' = bg_color
        )
      ),
      list(
        'selector' = 'edge',
        'style' = list(
          'line-color' = line_color
        )
      )
    )
    return(c(default_stylesheet, new_styles))
  }
)

app$run_server()
