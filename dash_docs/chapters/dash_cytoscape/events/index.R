library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashCytoscape)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  p5e1 = utils$LoadExampleCode('dash_docs/chapters/dash_cytoscape/events/examples/p5e1.R'),
  p5e2 = utils$LoadExampleCode('dash_docs/chapters/dash_cytoscape/events/examples/p5e2.R'),
  p5e3 = utils$LoadExampleCode('dash_docs/chapters/dash_cytoscape/events/examples/p5e3.R')
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

layout <- htmlDiv(list(
  htmlH1("Cytoscape Event Callbacks"),
  dccMarkdown("
In [part 4](/cytoscape/callbacks), we showed how to update Cytoscape with
other components by assigning callbacks that output to `'elements',
'stylesheet', 'layout'`. Moreover, it is also possible to use properties
of Cytoscape as an input to callbacks, which can be used to update other
components, or Cytoscape itself. Those properties are updated (which fires
the callbacks) when the user interact with elements in a certain way,
which justifies the name of event callbacks. You can find props such as
`tapNode`, which returns a complete description of the node object when
the user clicks or taps on a node, `mouseoverEdgeData`, which returns only
the data dictionary of the edge that was most recently hovered by the user.
The complete list can be found in the [Dash Cytoscape Reference](/cytoscape/reference).
  "),

  htmlH2("Simple callback construction"),
  dccMarkdown("
Let's look back at the same city example as the previous chapter:
  "),
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-event-callbacks',
  layout = list('name' = 'preset'),
  elements = c(edges, nodes),
  stylesheet = default_stylesheet,
  style = list('width' = '100%', 'height' = '450px')
)
  "),
  dccMarkdown("
This time, we will use the `tapNodeData` properties as input
to our callbacks, which will simply dump the content into an `htmlPre`:
  "),
  examples$p5e1$source,
  examples$p5e1$layout,
  dccMarkdown("
Notice that the `htmlDiv` is updated every time you click or tap a node,
and returns the data dictionary of the node. Alternatively, you can use
`tapNode` to obtain the entire element specification (given as a
dictionary), rather than just its `data`.
  "),

  htmlH2("Click, tap and hover"),
  dccMarkdown("
Let's now display the data generated whenever you click or hover over a node
or an edge. Simply replace the previous layout and callbacks by this:
  "),
  examples$p5e2$source,
  examples$p5e2$layout,

  htmlH2("Selecting multiple elements"),
  dccMarkdown("
Additionally, you can also display all the data currently selected, either
through a box selection (Shift+Click and drag) or by individually selecting
multiple elements while holding Shift:
  "),
  examples$p5e3$source,
  examples$p5e3$layout,

####################################################################################################
#   htmlH2("Advanced usage of callbacks"),
#   dccMarkdown("
# Those event callbacks enable more advanced interactions between components.
# In fact, you can even use them to update other `Cytoscape` arguments. The
# [`usage-stylesheet.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-stylesheet.py)
# example (hosted on the `dash-cytoscape` Github repo) lets you click to change the
# color of a node to purple, its targeted
# nodes to red, and its incoming nodes to blue. All of this is done using a
# single callback function, which takes as input the `tapNode` prop of the
# `Cytoscape` component along with a few dropdowns, and outputs to the
# `stylesheet` prop. You can try out this
# [interactive stylesheet demo](https://dash-gallery.plotly.host/cytoscape-stylesheet)
# hosted on the [Dash Deployment Servers](https://plotly.com/products/dash/).
#   "),
#   # BLOCK (arrow down snippet)
#   htmlDetails(
#     open = FALSE,
#     children = list(
#       htmlSummary('Expand to see how to interactively style your elements'),
#       utils$LoadAndDisplayComponent("
#       INSERT
#       ")
#     )
#   ),
#   dccMarkdown("
# Additionally, [`usage-elements.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-elements.py)
# lets you progressively expand your graph
# by using `tapNodeData` as the input and `elements` as the output.
# The app initially pre-loads the entire dataset, but only loads the graph
# with a single node. It then constructs four dictionaries that maps every
# single node ID to its following nodes, following edges, followers nodes,
# followers edges.
# Then, it lets you expand the incoming or the outgoing
# neighbors by clicking the node you want to expand. This
# is done through a callback that retrieves the followers (outgoing) or following
# (incoming) from the dictionaries, and add the to the `elements`.
# [Click here for the online demo](https://dash-gallery.plotly.host/cytoscape-elements).
#   "),
#   # BLOCK (arrow down snippet)
#   htmlDetails(
#     open = FALSE,
#     children = list(
#       htmlSummary('Expand to see how to construct the dictionaries'),
#       utils$LoadAndDisplayComponent("
#       INSERT
#       ")
#     )
#   ),
#   # BLOCK (arrow down snippet)
#   htmlDetails(
#     open = FALSE,
#     children = list(
#       htmlSummary('Expand to see how to generate elements'),
#       utils$LoadAndDisplayComponent("
#       INSERT
#       ")
#     )
#   ),
#   dccMarkdown("
# To see more examples of events, check out the [event callbacks demo](https://dash-gallery.plotly.host/cytoscape-events)
# (the source file is available as [`usage-events.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-events.py) on the project repo)
# and the [Cytoscape references](/cytoscape/reference).
#   "),
####################################################################################################

  htmlHr(),
  dccMarkdown("[Back to Cytoscape Documentation](/cytoscape)"),
  dccMarkdown("[Back to Dash Documentation](/)")
))
