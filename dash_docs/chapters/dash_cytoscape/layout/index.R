library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashCytoscape)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

# Element declaration
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

positions <- lapply(nodes, function(node) {return (node[['position']])})
names(positions) <- lapply(nodes, function(node) {return (node[['data']][['id']])})

layout <- htmlDiv(list(
  htmlH1("Cytoscape Layouts"),
  dccMarkdown("
The layout parameter of `cytoCytoscape` takes as argument a
named list specifying how the nodes should be positioned on the screen.
Every graph requires this named list with a value specified for the
`name` key. It represents a built-in display method, which is one of the
following:
- `preset`
- `random`
- `grid`
- `circle`
- `concentric`
- `breadthfirst`
- `cose`

All those layouts, along with their options, are described in the
[official Cytoscape documentation](http://js.cytoscape.org/#layouts).
There, you can find the exact keys accepted by your named list, enabling
advanced fine-tuning (demonstrated below).

If preset is given, the positions will be rendered based on the positions
specified in the elements. Otherwise, the positions will be computed by
Cytoscape.js behind the scene, based on the given items of the layout
named list. Let's start with an example of declaring a graph with a preset
layout:
  "),
  # Block 2.1
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-layout-1',
  elements = elements,
  style = list('width' = '100%', 'height' = '350px'),
  layout = list(
    'name' = 'preset'
  )
)
  "),
  dccMarkdown("
> Here, we provided toy elements using geographically positioned nodes. If
> you'd like to reproduce this example by yourself, check out the code
> below.
  "),
  htmlDetails(
    open = FALSE,
    children = list(
      htmlSummary('View Elements Declaration'),
      utils$LoadAndDisplayComponent("
# Element declaration
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
  "
      )
    )
  ),

  htmlH2("Display Methods"),
  dccMarkdown("
In most cases, the position of the nodes will not be given. In these
cases, one of the built-in methods can be used. Let's see what happens
when the value of `name` is set to `'circle'` or `'grid'`
  "),
  # Block 2.2
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-layout-2',
  elements = elements,
  style = list('width' = '100%', 'height' = '350px'),
  layout = list(
    'name' = 'circle'
  )
)
  "),
  # Block 2.3
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-layout-3',
  elements = elements,
  style = list('width' = '100%', 'height' = '350px'),
  layout = list(
    'name' = 'grid'
  )
)
  "),

  htmlH2("Fine-tuning the Layouts"),
  dccMarkdown("
For any given `name` item, a collection of keys are accepted by the layout
named list. For example, the
[`grid` layout](http://js.cytoscape.org/#layouts/grid)
will accept `row` and `cols`, the
[`circle` layout](http://js.cytoscape.org/#layouts/circle) `radius`
and `startAngle`, and so forth. Here is the grid layout
with the same graph as above, but with different layout options:
  "),
  # Block 2.4
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-layout-4',
  elements = elements,
  style = list('width' = '100%', 'height' = '350px'),
  layout = list(
    'name' = 'grid',
    'rows' = 3
  )
)
  "),
  dccMarkdown("
In the case of the circle layout, we can force the nodes to start and end
at a certain angle in radians (import `math` for this example):
  "),
  # Block 2.5
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-layout-5',
  elements = elements,
  style = list('width' = '100%', 'height' = '350px'),
  layout = list(
    'name' = 'circle',
    'radius' = 250,
    'startAngle' = pi * 1/6,
    'sweep' = pi * 2/3
  )
)
  "),
  dccMarkdown("
For the `breadthfirst` layout, a tree is created from the existing nodes
by performing a breadth-first search of the graph. By default, the root(s)
of the tree is inferred, but can also be specified as an option. Here is
how the graph would look like if we choose New York City as the root:
  "),
  # Block 2.6
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-layout-6',
  elements = elements,
  style = list('width' = '100%', 'height' = '350px'),
  layout = list(
    'name' = 'breadthfirst',
    'roots' = '[id = \"nyc\"]'
  )
)
  "),
  dccMarkdown("
Here is what would happen if we chose Montreal and Vancouver instead:
  "),
  # Block 2.7
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-layout-7',
  elements = elements,
  style = list('width' = '100%', 'height' = '350px'),
  layout = list(
    'name' = 'breadthfirst',
    'roots' = '#van, #mtl'
  )
)
  "),
  dccMarkdown("
> Notice here that we are not giving the ID of the nodes to the `roots`
> key, but instead using a specific syntax to select the desired elements.
> This concept of [selector is extensively documented in Cytoscape.js](http://js.cytoscape.org/#selectors),
> and will be further explored in [part 3](/cytoscape/styling).
> We follow the same syntax as the Javascript library.

For preset layouts, you can also specify the positions for which you would like to render each
of your nodes:
  "),
  # Block 2.8
  utils$LoadAndDisplayComponent("
positions <- lapply(nodes, function(node) {return (node[['position']])})
names(positions) <- lapply(nodes, function(node) {return (node[['data']][['id']])})

cytoCytoscape(
  id = 'cytoscape-layout-8',
  elements = elements,
  style = list('width' = '100%', 'height' = '350px'),
  layout = list(
    'name' = 'preset',
    'positions' = positions
  )
)
  "),
  dccMarkdown("
> In the callbacks chapter, you will learn how to interactively update your layout; in order
> to use `preset`, you will need to specify the position of each node.
  "),

  htmlH2("Physics-based Layouts"),
  dccMarkdown("
Additionally, the `cose` layout can be used to position the nodes using
a force-directed layout by simulating attraction and repulsion among the
elements, based on the paper by
[Dogrusoz et al, 2009](https://dl.acm.org/citation.cfm?id=1498047).
  "),
  # Block 2.9
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-layout-9',
  elements = elements,
  style = list('width' = '100%', 'height' = '350px'),
  layout = list(
    'name' = 'cose'
  )
)
  "),

####################################################################################################
#   htmlH2("Loading External Layout"),
#   dccMarkdown("
# > External layouts are now available! Update your `dash-cytoscape` to
# > [version 0.1.1](https://github.com/plotly/dash-cytoscape/pull/50) or later.
#
# The following external layouts are distributed with the official `dash-cytoscape` library:
# * [cose-bilkent](https://github.com/cytoscape/cytoscape.js-cose-bilkent)
# * [cola](https://github.com/cytoscape/cytoscape.js-cola)
# * [euler](https://github.com/cytoscape/cytoscape.js-dagre)
# * [spread](https://github.com/cytoscape/cytoscape.js-spread)
# * [dagre](https://github.com/cytoscape/cytoscape.js-dagre)
# * [klay](https://github.com/cytoscape/cytoscape.js-klay)
#
# In order to use them, you will need to use the `load_extra_layouts()` function from
# `dash_cytoscape`:
#   "),
#   # Block 2.10
#   utils$LoadAndDisplayComponent("htmlH2('BLOCK 2.10 (LoadExampleCode)')"),
#   dccMarkdown("
# We also provided a
# [demo app directly derived from `usage-elements`](https://github.com/plotly/dash-cytoscape/blob/master/demos/usage-elements-extra.py),
# but with the option to use the external layouts.
#
# > Make sure you use external layouts only when necessary. The distribution package takes
# > almost 3x more space than the regular bundle, which means that it will take more time to
# > load your apps, especially on slower networks.
# > [This image](https://github.com/plotly/dash-cytoscape/blob/master/demos/images/fast3g-cytoscape.PNG)
# > shows how long it would take to load the dev package on a slower network.
#   "),
####################################################################################################

  htmlHr(),
  dccMarkdown("[Back to Cytoscape Documentation](/cytoscape)"),
  dccMarkdown("[Back to Dash Documentation](/)")
))
