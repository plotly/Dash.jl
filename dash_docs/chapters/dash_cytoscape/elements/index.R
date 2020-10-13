library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashCytoscape)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  p1e1 = utils$LoadExampleCode('dash_docs/chapters/dash_cytoscape/elements/examples/p1e1.R')
)

my_stylesheet <- list(
  # Group selectors
  list(
    'selector' = 'node',
    'style' = list(
      'content' = 'data(label)'
    )
  ),
  # Class selectors
  list(
    'selector' = '.red',
    'style' = list(
      'background-color' = 'red',
      'line-color' = 'red'
    )
  ),
  list(
    'selector' = '.triangle',
    'style' = list(
      'shape' = 'triangle'
    )
  )
)

layout <- htmlDiv(list(
  htmlH1("Cytoscape Elements"),

  htmlH2("Element Declaration"),
  dccMarkdown("
Each element is defined by a named list declaring its purpose and
describing its properties. Usually, you specify what group the
element belongs to (i.e. if it's a node or an edge), indicate what
position you want to give to your element (if it's a node), or what data
it contains. In fact, the `data` and `position` names themselves refer
to named lists, where each item specifies an aspect of the data or
position.

In the case of `data`, the typical names fed to the named lists are:
- `id`: The index of the element, useful when you want to reference it
- `label`: The name associated with the element if you wish to display it

If your element is an edge, the following names are required in your `data`
named list:
- `source`: The `id` of the source node, where the edge starts
- `target`: The `id` of the target node, where the edge ends

The `position` named list takes as items the `x` and `y` position of the
node. If you use any other layout than `preset`, or if the element is an
edge, the position item will be ignored.

If we want a graph with two nodes, and an edge connecting those two nodes,
we effectively need three of those element named lists, grouped as a list:
  "),
  # Block 1.1
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-elements-basic',
  layout = list('name' = 'preset'),
  style = list('width' = '100%', 'height' = '400px'),
  elements = list(
    # The nodes elements
    list('data' = list('id' = 'one', 'label' = 'Node 1'), 'position' = list('x' = 50, 'y' = 50)),
    list('data' = list('id' = 'two', 'label' = 'Node 2'), 'position' = list('x' = 200, 'y' = 200)),
    # The edge elements
    list('data' = list('source' = 'one', 'target' = 'two', 'label' = 'Node 1 to 2'))
  )
)
  "),
  dccMarkdown("
Notice that we also need to specify the `id`, the `layout`, and the `style`
of Cytoscape. The `id` parameter is needed for assigning callbacks,
`style` lets you specify the CSS style of the component (similarly to core
components), and layout tells you how to arrange your graph. It is described
in depth in [part 2](/cytoscape/layout), so all you need to know is that
`'preset'` will organize the nodes according to the positions you specified.

The official Cytoscape.js documentation nicely outlines the [JSON format
for declaring elements](http://js.cytoscape.org/#notation/elements-json).
  "),

  htmlH2("Boolean Properties"),
  dccMarkdown("
In addition to the properties presented above, the element named list can
also accept boolean items that specify its state. We extend the previous
example in the following way:
  "),
  # Block 1.2
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-elements-boolean',
  layout = list('name' = 'preset'),
  style = list('width' = '100%', 'height' = '400px'),
  elements = list(
    list(
      'data' = list('id' = 'one', 'label' = 'Locked'),
      'position' = list('x' = 75, 'y' = 75),
      'locked' = TRUE
    ),
    list(
      'data' = list('id' = 'two', 'label' = 'Selected'),
      'position' = list('x' = 75, 'y' = 200),
      'selected' = TRUE
    ),
    list(
      'data' = list('id' = 'three', 'label' = 'Not Selectable'),
      'position' = list('x' = 200, 'y' = 75),
      'selectable' = FALSE
    ),
    list(
      'data' = list('id' = 'four', 'label' = 'Not grabbable'),
      'position' = list('x' = 200, 'y' = 200),
      'grabbable' = FALSE
    ),
    list('data' = list('source' = 'one', 'target' = 'two')),
    list('data' = list('source' = 'two', 'target' = 'three')),
    list('data' = list('source' = 'three', 'target' = 'four')),
    list('data' = list('source' = 'two', 'target' = 'four'))
  )
)
  "),
  dccMarkdown("
> Note that those boolean properties can be overwritten by certain Cytoscape
> parameters such as `autoungrabify` or `autounselectify`. Please refer to
> [the reference](/cytoscape/reference) for more information.
  "),

  htmlH2("Classes"),
  dccMarkdown("
Similarly to CSS classes, element classes are used to style groups of
elements using a selector. We modify the previous example by giving
the elements a class or multiple classes (separated by a space), and
define a stylesheet that modifies the elements based on those classes.
  "),
  # Block 1.3
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-elements-classes',
  layout = list('name' = 'preset'),
  style = list('width' = '100%', 'height' = '400px'),
  stylesheet = my_stylesheet,
  elements = list(
    list(
      'data' = list('id' = 'one', 'label' = 'Modified Color'),
      'position' = list('x' = 75, 'y' = 75),
      'classes' = 'red' # Single class
    ),
    list(
      'data' = list('id' = 'two', 'label' = 'Modified Shape'),
      'position' = list('x' = 75, 'y' = 200),
      'classes' = 'triangle' # Single class
    ),
    list(
      'data' = list('id' = 'three', 'label' = 'Both Modified'),
      'position' = list('x' = 200, 'y' = 75),
      'classes' = 'red triangle' # Multiple classes
    ),
    list(
      'data' = list('id' = 'four', 'label' = 'Regular'),
      'position' = list('x' = 200, 'y' = 200)
    ),
    list('data' = list('source' = 'one', 'target' = 'two'), 'classes' = 'red'),
    list('data' = list('source' = 'two', 'target' = 'three')),
    list('data' = list('source' = 'three', 'target' = 'four'), 'classes' = 'red'),
    list('data' = list('source' = 'two', 'target' = 'four'))
  )
)
  "),
  dccMarkdown("
> The stylesheet parameter will be described in depth in [part 3](/cytoscape/styling)
> of this guide. We will show extensive examples of using selectors to
> style groups, classes, and data values. Expand below if you still
> want to take a look at the stylesheet used previously.
  "),
  htmlDetails(
    open = FALSE,
    children = list(
      htmlSummary('View the Stylesheet'),
      utils$LoadAndDisplayComponent("
my_stylesheet <- list(
  # Group selectors
  list(
    'selector' = 'node',
    'style' = list(
      'content' = 'data(label)'
    )
  ),
  # Class selectors
  list(
    'selector' = '.red',
    'style' = list(
      'background-color' = 'red',
      'line-color' = 'red'
    )
  ),
  list(
    'selector' = '.triangle',
    'style' = list(
      'shape' = 'triangle'
    )
  )
)
  "
      )
    )
  ),

  htmlH2("Compound Nodes"),
  dccMarkdown("
A concept introduced in Cytoscape.js, compound nodes are nodes that
contain (parent), or are contained (child) inside another node. A parent
node does not have have a position nor a size, since those values are
automatically calculated based on how the children nodes are configured.

Here is the example of an app using compound nodes:
  "),
  # Block 1.4
  examples$p1e1$source,
  examples$p1e1$layout,

  htmlHr(),
  dccMarkdown("[Back to Cytoscape Documentation](/cytoscape)"),
  dccMarkdown("[Back to Dash Documentation](/)")
))
