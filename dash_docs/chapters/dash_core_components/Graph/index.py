# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout =  html.Div(children=[
    html.H1('Graph Examples and Reference'),
    rc.Markdown("""
    The dcc.Graph component can be used to render any plotly-powered data visualization,
    passed as the `figure` argument.
    """),
    html.H2('Primer on Plotly Graphing Library'),
    rc.Markdown("""
        - The [**Plotly Graphing Library**](https://plot.ly/python),
        known as the package package `plotly`, generates "figures".
        These are used in `dcc.Graph` with e.g. `dcc.Graph(figure=fig)`
        with `fig` a plotly figure.
        - **To get started with plotly**, learn how its documentation is organized:
            1. Learn the architecture of the `figure`: https://plot.ly/python/creating-and-updating-figures/
            2. Every chart type has a set of examples at a unique URL.
            Familiarize yourself with the structure of these pages. Google is your friend.
            For example "Plotly Python Histogram Charts" is documented at
            https://plot.ly/python/histogram
            3. Plotly Express is the recommended high-level interface.
            Understand where it fits in by reading 1.
            Once you understand its structure, you can see all of the arguments in the
            "API Reference" page documented here: https://plot.ly/python-api-reference/plotly.express.html
            3. Every aspect of a chart is configurable.
            Read through 1 to understand the low-level `figure` interface and how to
            modify the properties of a generated figure.
            Once you understand it, view _all_ of the
            properties by visiting the "Figure Reference" page at https://plot.ly/python/reference.
            4. If you can't generate the graph easily with `px`, then learn the
            `graph_objects` structure by reading 1 and understanding
            the structure of the figure via https://plot.ly/python/reference.
        - Plotly supports 40-50 different chart types. Learn more by navigating
        https://plot.ly/python/
        - In development, you can create figures by running Dash apps or
        in other environments like Jupyter, your console, and more.
        If you are using the interface outside of Dash, then calling
        `fig.show()` will always display the graph (either in your browser
        or inline directly in your environment). To see all of these rendering
        environments, see https://plot.ly/python/renderers/.
    """),
    html.H2('Examples'),
    html.H3('Plotly Express in Dash'),
    dcc.Markdown('The `fig` object is passed directly into the `figure` property of `dcc.Graph`:'),
    rc.ComponentBlock('''
import dash_core_components as dcc
import plotly.express as px

df = px.data.iris() # iris is a pandas DataFrame
fig = px.scatter(df, x="sepal_width", y="sepal_length")

dcc.Graph(figure=fig)
    '''),

    dcc.Markdown("""
    ### Using the Low-Level Interface with `go.Figure`

    Read through (1) above to learn more about the difference between `px` & `go.Figure`.
    """),
    rc.ComponentBlock('''import dash_core_components as dcc
import plotly.graph_objs as go
fig = go.Figure(data=[go.Scatter(x=[1, 2, 3], y=[4, 1, 2])])
dcc.Graph(
        id='example-graph-2',
        figure=fig
    )
''', style=styles.code_container),

    dcc.Markdown("""
    ### Using the Low-Level Interface with Dicts & Lists

    Read through (1) above to learn more about the difference between `px`, `go.Figure`, and `dicts` & `lists`.
    """),
    rc.ComponentBlock('''import dash_core_components as dcc
dcc.Graph(
        id='example-graph',
        figure={
            'data': [
                {'x': [1, 2, 3], 'y': [4, 1, 2], 'type': 'bar', 'name': 'SF'},
                {'x': [1, 2, 3], 'y': [2, 4, 5], 'type': 'bar', 'name': u'Montréal'},
            ],
            'layout': {
                'title': 'Dash Data Visualization'
            }
        }
    )
''', style=styles.code_container),

    html.H2('Interactive Graphing with Callbacks'),
    rc.Markdown("""
    The <dccLink href="/interactive-graphing" children="Interactive Visualizations"/> tutorial explains how
    to capture user interaction events with a `dcc.Graph`, and how to update the
    `figure` property in callbacks.

    Some advanced features are documented in [community forum](https://community.plot.ly/) posts:

    - How to preserve the UI state (zoom level etc.) of a Graph when updating the Graph in a callback
    https://community.plot.ly/t/preserving-ui-state-like-zoom-in-dcc-graph-with-uirevision/15793
    - Graph transitions for smooth transitions or animations on Graph updates
    https://community.plot.ly/t/exploring-a-transitions-api-for-dcc-graph/15468
    """),

    html.H2('Graph Resizing and Responsiveness'),
    rc.Markdown("""

    There are quite a few options that you can take advantage of if
    you want the size of your graph to be reactive.

    The default `plotly.js` behavior dictates that the graph should
    resize upon window resize. However, in some cases, you might want
    to resize the graph based on the size of its parent container
    instead. (You can set the size of the parent container with the
    `style.height` and `style.width` properties.)

    The `responsive` property of the `dcc.Graph` component allows you
    to define your desired behavior. In short, it accepts as a value
    `True`, `False`, or `'auto'`:

    * `True` forces the graph to be responsive to window and parent
      resize, regardless of any other specifications in
      `figure.layout` or `config`
    * `False` forces the graph to be non-responsive to window and
      parent resize, regardless of any other specifications in
      `figure.layout` or `config`
    * `'auto'` preserves the legacy behavior (size and resizability
      are determined by values specified in `figure.layout` and
      `config.responsive`)

    """),

    html.H3('How Resizing Works - Advanced'),
    rc.Markdown("""

    The properties of `dcc.Graph` that can control the size of the
    graph (other than `responsive`) are:

    * `figure.layout.height` - explicitly sets the height
    * `figure.layout.width` - explicitly sets the width
    * `figure.layout.autosize` - if `True`, sets the height and width
      of the graph to that of its parent container
    * `config.responsive` - if `True`, changes the height and width of
      the graph upon window resize

    The `responsive` property works in conjunction with the above
    properties in the following way:

    * `True`: `config.responsive` and `figure.layout.autosize` are
    overriden with `True` values, and `figure.layout.height` and
    `figure.layout.width` are unset
    * `False`: `config.responsive` and `figure.layout.autosize` are
      both overriden with `False` values
    * `'auto'`: the resizability of the plot is determined the
      same way as it used to be (i.e., with the four properties above)

  """),

    html.H3('Graph Properties'),
    rc.ComponentReference('Graph')
])
