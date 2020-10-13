library(dash)
library(dashHtmlComponents)
library(dashCytoscape)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      cytoCytoscape(
        id = 'cytoscape-two-nodes',
        layout = list('name' = 'preset'),
        style = list('width' = '100%', 'height' = '400px'),
        elements = list(
          list('data' = list('id' = 'one', 'label' = 'Node 1'), 'position' = list('x' = 75, 'y' = 75)),
          list('data' = list('id' = 'two', 'label' = 'Node 2'), 'position' = list('x' = 200, 'y' = 200)),
          list('data' = list('source' = 'one', 'target' = 'two'))
        )
      )
    )
  )
)

app$run_server()
