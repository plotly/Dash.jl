library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)
library(dashCytoscape)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      cytoCytoscape(
        id = 'cytoscape-compound',
        layout = list('name' = 'preset'),
        style = list('width' = '100%', 'height' = '450px'),
        stylesheet = list(
          list(
            'selector' = 'node',
            'style' = list('content' = 'data(label)')
          ),
          list(
            'selector' = '.countries',
            'style' = list('width' = 5)
          ),
          list(
            'selector' = '.cities',
            'style' = list('line-style' = 'dashed')
          )
        ),
        elements = list(
          # Parent Nodes
          list(
            'data' = list('id' = 'us', 'label' = 'United States')
          ),
          list(
            'data' = list('id' = 'can', 'label' = 'Canada')
          ),
          
          # Children Nodes
          list(
            'data' = list('id' = 'nyc', 'label' = 'New York', 'parent' = 'us'),
            'position' = list('x' = 100, 'y' = 100)
          ),
          list(
            'data' = list('id' = 'sf', 'label' = 'San Francisco', 'parent' = 'us'),
            'position' = list('x' = 100, 'y' = 200)
          ),
          list(
            'data' = list('id' = 'mtl', 'label' = 'Montreal', 'parent' = 'can'),
            'position' = list('x' = 400, 'y' = 100)
          ),
          
          # Edges
          list(
            'data' = list('source' = 'can', 'target' = 'us'),
            'classes' = 'countries'
          ),
          list(
            'data' = list('source' = 'nyc', 'target' = 'sf'),
            'classes' = 'cities'
          ),
          list(
            'data' = list('source' = 'sf', 'target' = 'mtl'),
            'classes' = 'cities'
          )
        )
      )
    )
  )
)

app$run_server()

