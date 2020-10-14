module chapters_interactive_graphing

using Dash, DashHtmlComponents, DashCoreComponents

export examples

include("../../utils.jl")

crossfilter_recipe = LoadExampleCode("./dash_docs/chapters/graph_crossfiltering/examples/crossfilter-recipe.jl")

interactive_graph_1 = LoadExampleCode("./dash_docs/chapters/graph_crossfiltering/examples/interactive-graph-1.jl")

interactive_graph_2 = LoadExampleCode("./dash_docs/chapters/graph_crossfiltering/examples/interactive-graph-2.jl")

examples = [crossfilter_recipe, interactive_graph_1, interactive_graph_2]

app =  dash()

crossfilter_recipe.callback!(app)
interactive_graph_1.callback!(app)
interactive_graph_2.callback!(app)

app.layout = html_div() do
    html_h1("Interactive Visualizations"),
    html_blockquote(dcc_markdown("This is the 4th chapter of the [Dash Tutorial](/).
    The [previous chapter](/basic-callbacks) covered basic callback usage and the [next chapter](/state)
    describes how to share data between callbacks. Just getting started? Make sure to [install the necessary
    dependencies](/installation)")),
    dcc_markdown("
    The `DashCoreComponents` package includes a component called `Graph`.exec

    `Graph` renders interactive visualizations using the open source [plotly.js](https://github.com/plotly/plotly.js) JavaScript
    graphing library. Plotly.js supports over 35 chart types and renders charts in both vector-quality SVG and high-performance
    WebGL.

    The `figure` argument in the `dcc_graph` component is the same `figure` argument that is used by
    `plotlyjs.jl`, an open source Julia graphing library. Check out
    the [plotlyjs.jl documentation](http://juliaplots.org/PlotlyJS.jl/stable/) and gallery to learn more.

    Dash components are described declaratively by a set of attributes. All of these attributes can be updated by callback
    functions, but only a subset of these attributes are updated through user interaction, such as when you click on an
    option in a `Dropdown` component and the `value` property of that component changes.

    The `Graph` component has four attributes that can change through user interaction: `hoverData`, `clickData`, `selectedData`,
    and `relayoutData`. THese properties update when you hover over points, click on points, or select regions in a graph.

    Here's a simple example that prints these attributes to the screen.
    "),
    interactive_graph_1.source_code,
    interactive_graph_1.layout,
    dcc_markdown("""
    ### Update Graphs on Hover

    Let's update our world indicators example from the previous chapter by updating time series
    when we hover over points in our scatter plot.

    """),

    interactive_graph_2.source_code,
    interactive_graph_2.layout,
    dcc_markdown("""

    Try mousing over the points in the scatter plot on the left.
    Notice how the line graphs on the right update based off of the point that you are hovering over.

    ### Generic Crossfilter Recipe

    Here's a slightly more generic example for crossfiltering across a six-column dataset.
    Each scatter plot's selection filters the underlying dataset.

    """),
    crossfilter_recipe.source_code,
    crossfilter_recipe.layout,
    dcc_markdown("""

    Try clicking and dragging in any of the plots to filter different regions.
    On every selection, the three graph callbacks are fired with the latest selected regions of each plot.
    A dataframe is filtered based off of the selected points and the graphs are replotted
    with the selected points highlighted and the selected region drawn as a dashed rectangle.

    """),

    dcc_markdown("""
    ### Current Limitations

    There are a few limitations in graph interactions right now.

    * It is not currently possible to customize the style of the hover interactions
    or the select box. This issue is being worked on in https://github.com/plotly/plotly.js/issues/1847.

    There's a lot that you can do  with these interactive plotting features. If you need
    help exploring your use case, open up a thread in the [Dash Community Forum](https://community.plotly.com/c/dash/julia/20)

    The next chapter of the Dash User Guide explains how to share data between
    callbacks.

    [Dash Tutorial Part 5: Sharing Data Between Callbacks](/sharing-data-between-callbacks)
    """),

    html_hr(),
    dcc_markdown("[Back to the table of contents](/)")

end

end
