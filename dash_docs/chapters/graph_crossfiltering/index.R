library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)
source('dash_docs/styles.R')
source('dash_docs/components.R')

examples <- list(
  interactive_graph_1 = utils$LoadExampleCode('dash_docs/chapters/graph_crossfiltering/examples/interactive-graph-1.R'),
  interactive_graph_2 = utils$LoadExampleCode('dash_docs/chapters/graph_crossfiltering/examples/interactive-graph-2.R')
  # crossfilter_recipe = utils$LoadExampleCode('dash_docs/chapters/graph_crossfiltering/examples/crossfilter_recipe.R')
)

layout <- htmlDiv(list(
  dccMarkdown("
# Interactive Visualizations

> This is the *4th* chapter of the [Dash Tutorial](/).
> The [previous chapter](/basic-callbacks) covered callbacks with `state`
> and the [next chapter](/sharing-data-between-callbacks) describes how to
> share data between callbacks.
> Just getting started? Make sure to [install the necessary dependencies](/installation).

The `dashCoreComponents` library includes a component called `dccGraph`.

`dccGraph` renders interactive data visualizations using the open source
[plotly.js](https://github.com/plotly/plotly.js) JavaScript graphing
library. Plotly.js supports over 35 chart types and renders charts in
both vector-quality SVG and high-performance WebGL.

The `figure` argument in the `dccGraph` component is
the same `figure` argument that is used by `plotly.R`, Plotly's
open source R graphing library.
Check out the [plotly.R documentation and gallery](https://plotly.com/r/)
to learn more.

Dash components are described declaratively by a set of attributes.
All of these attributes can be updated by callback functions, but only
a subset of these attributes are updated through user interaction, such as
when you click on an option in a `dccDropdown` component and the
`value` property of that component changes.

The `dccGraph` component has four attributes that can change
through user-interaction: `hoverData`, `clickData`, `selectedData`,
`relayoutData`.
These properties update when you hover over points, click on points, or
select regions of points in a graph.

"),
  # Example of interactive visualizations 1
  Syntax(
    children = examples$interactive_graph_1$source,
    summary="Here's an simple example that prints these attributes to the screen."
    ),
Example(examples$interactive_graph_1$layout),
  htmlHr(),
  dccMarkdown("
### Update Graphs on Hover
"),
  # Example of interactive visualizations 2
  Syntax(examples$interactive_graph_2$source,
         summary = "Let's update our world indicators example from the previous
         chapter by updating time series when we hover over points in our scatter plot."),
  Example(examples$interactive_graph_2$layout),

  dccMarkdown("
Try mousing over the points in the scatter plot on the left.
Notice how the line graphs on the right update based off of the point that you are hovering over.
"),
  htmlHr(),
  dccMarkdown("
### Generic Crossfilter Recipe
"),
Syntax(examples$crossfilter_recipe$source,
       summary = "Here's a slightly more generic example for crossfiltering across a six-column data set.
Each scatter plot's selection filters the underlying dataset."),
  # Example of interactive visualizations 3
#examples$crossfilter_recipe$layout,

  htmlImg(
    src='https://github.com/plotly/dash-docs/raw/master/images/select.gif',
    alt='Dash Data Selection Example',
    style=list(
      width = '100%', border = 'thin lightgrey solid'
    )),
#   dccMarkdown("
# ![ ](https://raw.githubusercontent.com/plotly/dash-docs/master/images/select.gif)
#   "),

  dccMarkdown("
Try clicking and dragging in any of the plots to filter different regions.
On every selection, the three graph callbacks are fired with the latest selected regions of each plot.
The dataframe is filtered based off of the selected points and
the graphs are replotted with the selected points highlighted and
the selected region drawn as a dashed rectangle.

> As an aside, if you find yourself filtering and visualizing highly-dimensional datasets,
> you should consider checking out the [parallel coordinates](https://plotly.com/r/parallel-coordinates-plot/) chart type.

### Current Limitations
There are a few limitations in graph interactions right now.
- It is not currently possible to customize the style of the hover interactions or the select box.
This issue is being worked on in
[Customized Click, Hover, and Selection Styles or Traces #1847](https://github.com/plotly/plotly.js/issues/1847).
  "),
  htmlHr(),
  dccMarkdown("
There's a lot that you can do with these interactive plotting features.
If you need help exploring your use case, open up a thread in the [Dash Community Forum](https://community.plotly.com/c/dash?_ga=2.198896623.192781799.1553018107-1965683241.1552615001).
  "),
  htmlHr(),
  dccMarkdown("
The next chapter of the Dash User Guide explains how to share data between callbacks.
  "),
  dccLink(
    'Dash Tutorial Part 5. Sharing Data Between Callbacks',
    href='/sharing-data-between-callbacks'
  ),
  htmlHr(),
  dccMarkdown("
[Back to the Table of Contents](/)
  ")
))
