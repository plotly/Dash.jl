library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashCytoscape)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  p4e1 = utils$LoadExampleCode('dash_docs/chapters/dash_cytoscape/callbacks/examples/p4e1.R'),
  p4e2 = utils$LoadExampleCode('dash_docs/chapters/dash_cytoscape/callbacks/examples/p4e2.R'),
  p4e3 = utils$LoadExampleCode('dash_docs/chapters/dash_cytoscape/callbacks/examples/p4e3.R')
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

layout <- htmlDiv(list(
  htmlH1("Dash Callbacks for Cytoscape"),
  dccMarkdown("
[Dash callbacks](/getting-started-part-2) allow you to update your
Cytoscape graph via other components like dropdowns, buttons, and sliders.
If you have used Cytoscape.js before, you have probably used event handlers
to interactively update your graph; with Dash Cytoscape, we will instead
use callbacks.
  "),

  htmlH2("Changing Layouts"),
  dccMarkdown("
Consider the graph containing North American cities from the layout
chapter. We have shown in that chapter how to display the same graph in
multiple layouts. But what if we want to introduce the option for the
user to interactively update the layouts?

Recall the declaration of the graph:
  "),
  htmlDetails(
    open = FALSE,
    children = list(
      htmlSummary('View Elements Declaration'),
      utils$LoadAndDisplayComponent("
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
  # Block 4.1
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-update-layout',
  elements = elements,
  layout = list('name' = 'grid'),
  style = list('width' = '100%', 'height' = '400px')
)
  "),
  dccMarkdown("
What we want to modify is the argument to `layout`. To do so, we could use
a `dash_core_components.Dropdown` with the name of the layouts as options.
We could set the default value to 'grid', and force it to be unclearable
(since we do not want to pass a dictionary with null value to `Cytoscape`).
  "),
  # Block 4.2
  utils$LoadAndDisplayComponent("
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
)
  "),
  dccMarkdown("
The construction of the callback becomes extremely easy. We simply create
a function as such:
  "),
  # Block 4.3
  utils$LoadAndDisplayComponent("
app$callback(
  output = list(id = 'cytoscape-update-layout', property = 'layout'),
  params = list(
    input(id = 'dropdown-update-layout', property = 'value')
  ),
  function(layout) {
    return(
      list(
        'name' = layout
      )
    )
  }
)
  "),
  dccMarkdown("
In fact, it is even possible to animate the layouts after an update!
Simply enable `animate`:
  "),
  # Block 4.4
  utils$LoadAndDisplayComponent("
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
  "),
  dccMarkdown("
Piecing everything together, we get:
  "),
  # Block 4.5
  examples$p4e1$source,
  examples$p4e1$layout,
  dccMarkdown("
> Notice we did not include an animation for `preset`. As discussed in the layout chapter, you
> will need to specify the position of the nodes inside of the `layout` dictionary.
  "),
# ADD LATER: Check out [this example](https://github.com/plotly/dash-cytoscape/blob/master/demos/usage-preset-animation.py) for more details.

  htmlH2("Interactively update styles"),
  dccMarkdown("
Updating the stylesheet using Dash components is similar to updating
layouts, although it can get more complex. Indeed, you can choose to create
a default stylesheet, and append new styles to that stylesheet every time
a designated callback is fired. Let's take the following stylesheet:
  "),
  # Block 4.6
  utils$LoadAndDisplayComponent("
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
  "),
  dccMarkdown("
This is generally declared at the beginning of your script, before layout
declaration (therefore it is shared accross sessions). The city graph will
look something like this:
  "),
  # Block 4.7
  utils$LoadAndDisplayComponent("
cytoCytoscape(
  id = 'cytoscape-update-stylesheet',
  elements = elements,
  layout = list('name' = 'circle'),
  style = list('width' = '100%', 'height' = '450px'),
  stylesheet = default_stylesheet
)
  "),
  dccMarkdown("
We might want to use text fields to input the color we want to add:
  "),
  # Block 4.8
  utils$LoadAndDisplayComponent("
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
)
  "),
  dccMarkdown("
All we need now is to assign a callback that will add new styles to the
default stylesheet in order to change the default color:
  "),
  # Block 4.9
  utils$LoadAndDisplayComponent("
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
  "),
  dccMarkdown("
Notice that we are setting the line and background color to an empty
string when they are set to `NULL`; this is to avoid feeding `NULL`
to the dictionary, since it is not accepted by `Cytoscape`.

However, passing any string value to the dictionary is accepted, even when
the string value is not recognized. Therefore, the callback is fired every
time you type a new character, but the changes are only applied when
`Cytoscape` recognizes the input, which in this case could be the name of
a color, the hex code, or the rgb function.

Below, we show how the entire app is constructed:
  "),
  # Block 4.10
  examples$p4e2$source,
  examples$p4e2$layout,
  dccMarkdown("
In this example, we are not appending the new styles
directly to the default style, but instead concatenating
`default_stylesheet` with `new_styles`. This is because any modification
to `default_stylesheet` will be permanent, which is not a good thing if you
are hosting your app for many users (since `default_stylesheet` is shared
across all user sessions).
  "),
# ADD LATER:
# If you want to find more examples of styling using callbacks,
# check out the [`usage-stylesheet.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-stylesheet.py),
# example in the `dash-cytoscape` Github project. It presents a comprehensive
# overview of techniques for manipulating stylesheets in Dash Cytoscape.

  htmlH2("Adding and removing elements"),
  dccMarkdown("
One useful aspect of callbacks is the ability to add and remove elements.
By using elements as a state of your callback, you can decide to manipulate
it in order to add elements whenever another Dash component is updated.

Let's take as an example a simple app where you can add and remove nodes
by clicking two html buttons (with the same graph as above):
  "),
  # Block 4.11
  utils$LoadAndDisplayComponent("
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
)
  "),
  dccMarkdown("
The following callback would be needed:
  "),
  # Block 4.12
  utils$LoadAndDisplayComponent("
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
  "),
  dccMarkdown("
The first conditional `if int(btn_add) > int(btn_remove)` verifies whether
the add button was just clicked. If it wasn't, then the remove button is
verified with `elif int(btn_remove) > int(btn_add)`. If neither were clicked,
then we return the default `elements`.

The statement `if next_node_idx < len(nodes)` verifies if we have reached
the maximum number of nodes. If not, then we proceed to add the next node.
Similarly for the *remove* case: `if len(elements) > len(edges)` only
removes nodes if there is any remaining (so we don't remove any edge). If
neither conditions are met, we simply return the current elements.

It's important to *mutate* the `elements` object by passing it into the
callbacks as `State` (which is what we are doing here) rather than making
it a `global` variable. In general, `global` variables should be avoided
as they won't work when multiple users are viewing the app or when the app
is deployed with multiple gunicorn workers.

You can find the complete app below:
  "),
  # Block 4.13
  examples$p4e3$source,
  examples$p4e3$layout,

  htmlHr(),
  dccMarkdown("[Back to Cytoscape Documentation](/cytoscape)"),
  dccMarkdown("[Back to Dash Documentation](/)")
))
