library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashCytoscape)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  p3e1 = utils$LoadExampleCode('dash_docs/chapters/dash_cytoscape/styling/examples/p3e1.R')
)

simple_elements <- list(
  # Nodes
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
  # Edges
  list('data' = list('source' = 'one', 'target' = 'two'), 'classes' = 'red'),
  list('data' = list('source' = 'two', 'target' = 'three')),
  list('data' = list('source' = 'three', 'target' = 'four'), 'classes' = 'red'),
  list('data' = list('source' = 'two', 'target' = 'four'))
)

weighted_elements <- list(
  # Nodes
  list('data' = list('id' = 'A')),
  list('data' = list('id' = 'B')),
  list('data' = list('id' = 'C')),
  list('data' = list('id' = 'D')),
  list('data' = list('id' = 'E')),
  # Edges
  list('data' = list('source' = 'A', 'target' = 'B', 'weight' = 1)),
  list('data' = list('source' = 'A', 'target' = 'C', 'weight' = 2)),
  list('data' = list('source' = 'B', 'target' = 'D', 'weight' = 3)),
  list('data' = list('source' = 'B', 'target' = 'E', 'weight' = 4)),
  list('data' = list('source' = 'C', 'target' = 'E', 'weight' = 5)),
  list('data' = list('source' = 'D', 'target' = 'A', 'weight' = 6))
)

named_elements <- list(
  # Nodes
  list('data' = list('id' = 'A', 'firstname' = 'Albert')),
  list('data' = list('id' = 'B', 'firstname' = 'Bert')),
  list('data' = list('id' = 'C', 'firstname' = 'Charlie')),
  list('data' = list('id' = 'D', 'firstname' = 'Daniela')),
  list('data' = list('id' = 'E', 'firstname' = 'Emma')),
  # Edges
  list('data' = list('source' = 'A', 'target' = 'B')),
  list('data' = list('source' = 'A', 'target' = 'C')),
  list('data' = list('source' = 'B', 'target' = 'D')),
  list('data' = list('source' = 'B', 'target' = 'E')),
  list('data' = list('source' = 'C', 'target' = 'E')),
  list('data' = list('source' = 'D', 'target' = 'A'))
)

double_edged_nodes <- lapply(
  list('A', 'B', 'C', 'D'),
  function(node) {
    return(
      list('data' = list('id' = node))
    )
  }
)

double_edges <- lapply(
  list('AB', 'BA', 'BC', 'CB', 'CD', 'DC', 'DA', 'AD'),
  function(edge) {
    src <- substring(edge,1,1)
    tgt <- substring(edge,2,2)
    return(
      list('data' = list('id' = edge, 'source' = src, 'target' = tgt))
    )
  }
)

double_edged_el <- c(double_edged_nodes, double_edges)

directed_nodes <- lapply(
  list('A', 'B', 'C', 'D'),
  function(node) {
    list('data' = list('id' = node))
  }
)

directed_edges <- lapply(
  list('BA', 'BC', 'CD', 'DA'),
  function(edge) {
    src <- substring(edge,1,1)
    tgt <- substring(edge,2,2)
    return(
      list('data' = list('id' = edge, 'source' = src, 'target' = tgt))
    )
  }
)

directed_elements <- c(directed_nodes, directed_edges)

layout <- htmlDiv(list(
  htmlH1("Cytoscape Styling"),

  dccMarkdown("## The `stylesheet` parameter"),
  dccMarkdown("
Just like how the `elements` parameter takes as an input a list of
named lists specifying all the elements in the graph, the stylesheet takes
a list of named lists specifying the style for a group of elements, a
class of elements, or a single element. Each of these named lists accept
two keys:
- `'selector'`: A string indicating which elements you are styling.
- `'style'`: A named list specifying what exactly you want to modify. This
could be the width, height, color of a node, the shape of the arrow on an
edge, or many more.

Both [the selector string](http://js.cytoscape.org/#selectors) and
[the style named list](http://js.cytoscape.org/#style/node-body) are
exhaustively documented in the Cytoscape.js docs.
  "),
# ADD LATER:
# We will show examples
# that can be easily modified for any type of design, and you can create
# your own styles with the
# [online style editor](https://dash-gallery.plotly.host/cytoscape-advanced)
# (which you can use locally by running
# [`usage-advanced.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-advanced.py).

  htmlH2("Basic selectors and styles"),
  dccMarkdown("
We start by looking at the same example shown in the elements
chapter, but this time we examine the stylesheet:
  "),
  htmlDetails(
    open = FALSE,
    children = list(
      htmlSummary('View simple elements'),
      utils$LoadAndDisplayComponent("

simple_elements <- list(
  # Nodes
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
  # Edges
  list('data' = list('source' = 'one', 'target' = 'two'), 'classes' = 'red'),
  list('data' = list('source' = 'two', 'target' = 'three')),
  list('data' = list('source' = 'three', 'target' = 'four'), 'classes' = 'red'),
  list('data' = list('source' = 'two', 'target' = 'four'))
)
  "
      )
    )
  ),
  # Block 3.1
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id='cytoscape-styling-1',
  layout=list('name' = 'preset'),
  style=list('width' = '100%', 'height' = '400px'),
  elements=simple_elements,
  stylesheet=list(
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
)
  "),
  dccMarkdown("
In this example, we use the group and class selectors. Group selectors
consist of either the string `'node'` or the string `'edge'`, since an
element can only be one or the other.

To select a class, you simply pass `.className` to the selector, where
`className` is the name of one of the classes you assigned to some of your
elements. Notice in the example above that if an element has two or more
classes, it will accept all the styles that select it.

Here, we are simultaneously modifying the background and line color of all
the elements of class 'red'. This means that if the element is a node, then
it will be filled with red, and it is an edge, then the color of the line
will be red. Although this offers great flexibility, you need to be careful
with your declaration, since you won't receive warning if you use the wrong
key or make a typo. Standard RGB and Hex colors are accepted, along with
basic colors recognized by CSS.

Additionally, the `content` key takes as value what you want to display
above or next to the element on the screen, which in this case is the
label inside the `data` named list of the input element. Since we defined
a label for each element, that label will be displayed for every node.
  "),

  htmlH2("Comparing data items using selectors"),
  dccMarkdown("
A nice property of the selector is that it can select elements by comparing
a certain item of the data named lists with a given value. Say we have
some nodes with `id` A to E declared this way:
```
list('data': list('source': 'A', 'target': 'B', 'weight': 1))
```

where the `'weight'` key indicates the weight of your edge. You can find
the declaration below:
  "),
  htmlDetails(
    open = FALSE,
    children = list(
      htmlSummary('View weighted elements'),
      utils$LoadAndDisplayComponent("
weighted_elements <- list(
  # Nodes
  list('data' = list('id' = 'A')),
  list('data' = list('id' = 'B')),
  list('data' = list('id' = 'C')),
  list('data' = list('id' = 'D')),
  list('data' = list('id' = 'E')),
  # Edges
  list('data' = list('source' = 'A', 'target' = 'B', 'weight' = 1)),
  list('data' = list('source' = 'A', 'target' = 'C', 'weight' = 2)),
  list('data' = list('source' = 'B', 'target' = 'D', 'weight' = 3)),
  list('data' = list('source' = 'B', 'target' = 'E', 'weight' = 4)),
  list('data' = list('source' = 'C', 'target' = 'E', 'weight' = 5)),
  list('data' = list('source' = 'D', 'target' = 'A', 'weight' = 6))
)
  "
      )
    )
  ),
  dccMarkdown("
If you want to highlight all the of the edges above a certain weight
(e.g. 3), use the selector `'[weight > 3]'`. For example:
  "),
  # Block 3.2
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id='cytoscape-styling-2',
  layout=list('name' = 'circle'),
  style=list('width' = '100%', 'height' = '400px'),
  elements=weighted_elements,
  stylesheet=list(
    list(
      'selector' = 'edge',
      'style' = list(
        'label' = 'data(weight)'
      )
    ),
    list(
      'selector' = '[weight > 3]',
      'style' = list(
        'line-color' = 'blue'
      )
    )
  )
)
  "),
  dccMarkdown("
Similarly, if you want to have weights smaller or equal to 3, you would write:
  "),
  # Block 3.3
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id='cytoscape-styling-3',
  layout=list('name' = 'circle'),
  style=list('width' = '100%', 'height' = '400px'),
  elements=weighted_elements,
  stylesheet=list(
    list(
      'selector' = 'edge',
      'style' = list(
        'label' = 'data(weight)'
      )
    ),
    list(
      'selector' = '[weight <= 3]',
      'style' = list(
        'line-color' = 'blue'
      )
    )
  )
)
  "),
  dccMarkdown("
Comparisons also work for string matching problems. Given the same graph
as before, but with a data key `'firstname'` for each node:
```
list('data': list('id': 'A', 'firstname': 'Albert'))
```

We can select all the elements that match a specific pattern. For instance,
to style nodes where `'firstname'` contains the substring `'ert'`, we
declare:
  "),
  htmlDetails(
    open = FALSE,
    children = list(
      htmlSummary('View named elements'),
      utils$LoadAndDisplayComponent("
named_elements <- list(
  # Nodes
  list('data' = list('id' = 'A', 'firstname' = 'Albert')),
  list('data' = list('id' = 'B', 'firstname' = 'Bert')),
  list('data' = list('id' = 'C', 'firstname' = 'Charlie')),
  list('data' = list('id' = 'D', 'firstname' = 'Daniela')),
  list('data' = list('id' = 'E', 'firstname' = 'Emma')),
  # Edges
  list('data' = list('source' = 'A', 'target' = 'B')),
  list('data' = list('source' = 'A', 'target' = 'C')),
  list('data' = list('source' = 'B', 'target' = 'D')),
  list('data' = list('source' = 'B', 'target' = 'E')),
  list('data' = list('source' = 'C', 'target' = 'E')),
  list('data' = list('source' = 'D', 'target' = 'A'))
)
  "
      )
    )
  ),
  # Block 3.4
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id='cytoscape-styling-4',
  layout=list('name' = 'circle'),
  style=list('width' = '100%', 'height' = '400px'),
  elements=named_elements,
  stylesheet=list(
    list(
      'selector' = 'node',
      'style' = list(
        'label' = 'data(firstname)'
      )
    ),
    list(
      'selector' = '[firstname *= \"ert\"]',
      'style' = list(
        'background-color' = '#FF4136',
        'shape' = 'rectangle'
      )
    )
  )
)
  "),
  dccMarkdown("
Now, if we want to select all the elements where `'firstname'` *does not*
contain `'ert'`, then we can run:
  "),
  # Block 3.5
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id='cytoscape-styling-5',
  layout=list('name' = 'circle'),
  style=list('width' = '100%', 'height' = '400px'),
  elements=named_elements,
  stylesheet=list(
    list(
      'selector' = 'node',
      'style' = list(
        'label' = 'data(firstname)'
      )
    ),
    list(
      'selector' = '[firstname !*= \"ert\"]',
      'style' = list(
        'background-color' = '#FF4136',
        'shape' = 'rectangle'
      )
    )
  )
)
  "),
  dccMarkdown("
Other options also exist for matching specific parts of the string. For
example, if we want to only select the prefix, we can use `^=` as such:
  "),
  # Block 3.6
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id='cytoscape-styling-6',
  layout=list('name' = 'circle'),
  style=list('width' = '100%', 'height' = '400px'),
  elements=named_elements,
  stylesheet=list(
    list(
      'selector' = 'node',
      'style' = list(
        'label' = 'data(firstname)'
      )
    ),
    list(
      'selector' = '[firstname ^= \"Alb\"]',
      'style' = list(
        'background-color' = '#FF4136',
        'shape' = 'rectangle'
      )
    )
  )
)
  "),
  dccMarkdown("
This can also be prepended by modifiers. For example, `@` added in front
of an operator will render the string matched case insensitive.
  "),
  # Block 3.7
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id='cytoscape-styling-7',
  layout=list('name' = 'circle'),
  style=list('width' = '100%', 'height' = '400px'),
  elements=named_elements,
  stylesheet=list(
    list(
      'selector' = 'node',
      'style' = list(
        'label' = 'data(firstname)'
      )
    ),
    list(
      'selector' = '[firstname @^= \"alb\"]',
      'style' = list(
        'background-color' = '#FF4136',
        'shape' = 'rectangle'
      )
    )
  )
)
  "),
  dccMarkdown("
View the [complete list of matching operations](http://js.cytoscape.org/#selectors/data)
for data selectors.
  "),

  htmlH2("Styling edges"),
  htmlH3("Two-sided edges and curvature"),
  dccMarkdown("
Many methods exist to style edges in Dash Cytoscape. In some cases, you
might want different ways to display double-edged
  "),
  htmlDetails(
    open = FALSE,
    children = list(
      htmlSummary('View double-edged elements'),
      utils$LoadAndDisplayComponent("
double_edged_nodes <- lapply(
  list('A', 'B', 'C', 'D'),
  function(node) {
    return(
      list('data' = list('id' = node))
    )
  }
)

double_edges <- lapply(
  list('AB', 'BA', 'BC', 'CB', 'CD', 'DC', 'DA', 'AD'),
  function(edge) {
    src <- substring(edge,1,1)
    tgt <- substring(edge,2,2)
    return(
      list('data' = list('id' = edge, 'source' = src, 'target' = tgt))
    )
  }
)

double_edged_el <- c(double_edged_nodes, double_edges)
  "
      )
    )
  ),
  # Block 3.8
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id='cytoscape-styling-8',
  layout=list('name' = 'circle'),
  style=list('width' = '100%', 'height' = '400px'),
  elements=double_edged_el,
  stylesheet=list(
    list(
      'selector' = 'node',
      'style' = list(
        'label' = 'data(id)'
      )
    ),
    list(
      'selector' = '#AB, #BA',
      'style' = list(
        'curve-style' = 'bezier',
        'label' = 'bezier',
        'line-color' = 'red'
      )
    ),
    list(
      'selector' = '#AD, #DA',
      'style' = list(
        'curve-style' = 'haystack',
        'label' = 'haystack',
        'line-color' = 'blue'
      )
    ),
    list(
      'selector' = '#DC, #CD',
      'style' = list(
        'curve-style' = 'segments',
        'label' = 'segments',
        'line-color' = 'green'
      )
    )
    )
)
  "),
  dccMarkdown("
Many curve styles are accepted, and support further customization such as
the distance between edges and curvature radius. You can find them in
the [JavaScript docs](http://js.cytoscape.org/#style/bezier-edges).
  "),
  htmlH3("Edge Arrows"),
  dccMarkdown("
To better highlight the directed edges, we can add arrows of different
shapes, colors, and positions onto the edges. This is an example of using
different types of arrows, with the same graph above, but with certain
edges removed:
  "),
  htmlDetails(
    open = FALSE,
    children = list(
      htmlSummary('View directed elements'),
      utils$LoadAndDisplayComponent("
directed_nodes <- lapply(
  list('A', 'B', 'C', 'D'),
  function(node) {
    list('data' = list('id' = node))
  }
)

directed_edges <- lapply(
  list('BA', 'BC', 'CD', 'DA'),
  function(edge) {
    src <- substring(edge,1,1)
    tgt <- substring(edge,2,2)
    return(
      list('data' = list('id' = edge, 'source' = src, 'target' = tgt))
    )
  }
)

directed_elements <- c(directed_nodes, directed_edges)
  "
      )
    )
  ),
  # Block 3.9
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id='cytoscape-styling-9',
  layout=list('name' = 'circle'),
  style=list('width' = '100%', 'height' = '400px'),
  elements=directed_elements,
  stylesheet=list(
    list(
      'selector' = 'node',
      'style' = list(
        'label' = 'data(id)'
      )
    ),
    list(
      'selector' = 'edge',
      'style' = list(
        # The default curve style does not work with certain arrows
        'curve-style' = 'bezier'
      )
    ),
    list(
      'selector' = '#BA',
      'style' = list(
        'source-arrow-color' = 'red',
        'source-arrow-shape' = 'triangle',
        'line-color' = 'red'
      )
    ),
    list(
      'selector' = '#DA',
      'style' = list(
        'target-arrow-color' = 'blue',
        'target-arrow-shape' = 'vee',
        'line-color' = 'blue'
      )
    ),
    list(
      'selector' = '#BC',
      'style' = list(
        'mid-source-arrow-color' = 'green',
        'mid-source-arrow-shape' = 'diamond',
        'mid-source-arrow-fill' = 'hollow',
        'line-color' = 'green'
      )
    ),
    list(
      'selector' = '#CD',
      'style' = list(
        'mid-target-arrow-color' = 'black',
        'mid-target-arrow-shape' = 'circle',
        'arrow-scale' = 2,
        'line-color' = 'black'
      )
    )
  )
)
  "),
  dccMarkdown("
Notice here that we prepend a position indicator for the color and shape
keys. In the previous example, all four possible positions are displayed.
In fact, you can even the edges with multiple arrows, all with different
colors and shapes. View the
[complete list of edge arrow configurations](http://js.cytoscape.org/#style/edge-arrow).
  "),

  htmlH2("Displaying Images"),
  dccMarkdown("
It is possible to [display images inside nodes](http://js.cytoscape.org/#style/background-image),
as documented in Cytoscape.js. We show below a complete example of display
an interactive tree of animal phylogeny using images from Wikimedia.
  "),
  # Block 3.10
  examples$p3e1$source,
  examples$p3e1$layout,

  htmlHr(),
  dccMarkdown("[Back to Cytoscape Documentation](/cytoscape)"),
  dccMarkdown("[Back to Dash Documentation](/)")
))
