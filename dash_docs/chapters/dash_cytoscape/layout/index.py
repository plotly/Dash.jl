import math

import dash_cytoscape as cyto
import dash_core_components as dcc
import dash_html_components as html


from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc

nodes = [
    {
        'data': {'id': short, 'label': label},
        'position': {'x': 20*lat, 'y': -20*long}
    }
    for short, label, long, lat in (
        ('la', 'Los Angeles', 34.03, -118.25),
        ('nyc', 'New York', 40.71, -74),
        ('to', 'Toronto', 43.65, -79.38),
        ('mtl', 'Montreal', 45.50, -73.57),
        ('van', 'Vancouver', 49.28, -123.12),
        ('chi', 'Chicago', 41.88, -87.63),
        ('bos', 'Boston', 42.36, -71.06),
        ('hou', 'Houston', 29.76, -95.37)
    )
]

edges = [
    {'data': {'source': source, 'target': target}}
    for source, target in (
        ('van', 'la'),
        ('la', 'chi'),
        ('hou', 'chi'),
        ('to', 'mtl'),
        ('mtl', 'bos'),
        ('nyc', 'bos'),
        ('to', 'hou'),
        ('to', 'nyc'),
        ('la', 'nyc'),
        ('nyc', 'bos')
    )
]

elements = nodes + edges


Display = rc.CreateDisplay({
    'cyto': cyto,
    'elements': elements,
    'math': math,
    'nodes': nodes
})


layout = html.Div([

    rc.Markdown('''
    # Cytoscape Layouts

    The layout parameter of `cyto.Cytoscape` takes as argument a
    dictionary specifying how the nodes should be positioned on the screen.
    Every graph requires this dictionary with a value specified for the
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
    There, you can find the exact keys accepted by your dictionary, enabling
    advanced fine-tuning (demonstrated below).

    If preset is given, the positions will be rendered based on the positions
    specified in the elements. Otherwise, the positions will be computed by
    Cytoscape.js behind the scene, based on the given items of the layout
    dictionary. Let's start with an example of declaring a graph with a preset
    layout:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-layout-1',
        elements=elements,
        style={'width': '100%', 'height': '350px'},
        layout={
            'name': 'preset'
        }
    )
    '''),

    rc.Markdown('''
    > Here, we provided toy elements using geographically positioned nodes. If
    > you'd like to reproduce this example by yourself, check out the code
    > below.

    '''),

    html.Details(open=False, children=[
        html.Summary('View Elements Declaration'),
        rc.Markdown('''
        ```py
        nodes = [
            {
                'data': {'id': short, 'label': label},
                'position': {'x': 20*lat, 'y': -20*long}
            }
            for short, label, long, lat in (
                ('la', 'Los Angeles', 34.03, -118.25),
                ('nyc', 'New York', 40.71, -74),
                ('to', 'Toronto', 43.65, -79.38),
                ('mtl', 'Montreal', 45.50, -73.57),
                ('van', 'Vancouver', 49.28, -123.12),
                ('chi', 'Chicago', 41.88, -87.63),
                ('bos', 'Boston', 42.36, -71.06),
                ('hou', 'Houston', 29.76, -95.37)
            )
        ]

        edges = [
            {'data': {'source': source, 'target': target}}
            for source, target in (
                ('van', 'la'),
                ('la', 'chi'),
                ('hou', 'chi'),
                ('to', 'mtl'),
                ('mtl', 'bos'),
                ('nyc', 'bos'),
                ('to', 'hou'),
                ('to', 'nyc'),
                ('la', 'nyc'),
                ('nyc', 'bos')
            )
        ]

        elements = nodes + edges
        ```
        ''', style=styles.code_container),
    ]),

    rc.Markdown('''
    ## Display Methods

    In most cases, the position of the nodes will not be given. In these
    cases, one of the built-in methods can be used. Let's see what happens
    when the value of `name` is set to `'circle'` or `'grid'`
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-layout-2',
        elements=elements,
        style={'width': '100%', 'height': '350px'},
        layout={
            'name': 'circle'
        }
    )
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-layout-3',
        elements=elements,
        style={'width': '100%', 'height': '350px'},
        layout={
            'name': 'grid'
        }
    )
    '''),

    rc.Markdown('''

    ## Fine-tuning the Layouts

    For any given `name` item, a collection of keys are accepted by the layout
    dictionary. For example, the
    [`grid` layout](http://js.cytoscape.org/#layouts/grid)
    will accept `row` and `cols`, the
    [`circle` layout](http://js.cytoscape.org/#layouts/circle) `radius`
    and `startAngle`, and so forth. Here is the grid layout
    with the same graph as above, but with different layout options:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-layout-4',
        elements=elements,
        style={'width': '100%', 'height': '350px'},
        layout={
            'name': 'grid',
            'rows': 3
        }
    )
    '''),

    rc.Markdown('''
    In the case of the circle layout, we can force the nodes to start and end
    at a certain angle in radians (import `math` for this example):
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-layout-5',
        elements=elements,
        style={'width': '100%', 'height': '350px'},
        layout={
            'name': 'circle',
            'radius': 250,
            'startAngle': math.pi * 1/6,
            'sweep': math.pi * 2/3
        }
    )
    '''),

    rc.Markdown('''
    For the `breadthfirst` layout, a tree is created from the existing nodes
    by performing a breadth-first search of the graph. By default, the root(s)
    of the tree is inferred, but can also be specified as an option. Here is
    how the graph would look like if we choose New York City as the root:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-layout-6',
        elements=elements,
        style={'width': '100%', 'height': '350px'},
        layout={
            'name': 'breadthfirst',
            'roots': '[id = "nyc"]'
        }
    )
    '''),

    rc.Markdown('''
    Here is what would happen if we chose Montreal and Vancouver instead:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-layout-7',
        elements=elements,
        style={'width': '100%', 'height': '350px'},
        layout={
            'name': 'breadthfirst',
            'roots': '#van, #mtl'
        }
    )
    '''),

    rc.Markdown('''
    > Notice here that we are not giving the ID of the nodes to the `roots`
    > key, but instead using a specific syntax to select the desired elements.
    > This concept of [selector is extensively documented in Cytoscape.js](http://js.cytoscape.org/#selectors),
    > and will be further explored in <dccLink href="/cytoscape/styling" children="part 3"/>.
    > We follow the same syntax as the Javascript library.

    For preset layouts, you can also specify the positions for which you would like to render each
    of your nodes:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-layout-8',
        elements=elements,
        style={'width': '100%', 'height': '350px'},
        layout={
            'name': 'preset',
            'positions': {
                node['data']['id']: node['position']
                for node in nodes
            }
        }
    )
    '''),

    rc.Markdown('''
    > In the callbacks chapter, you will learn how to interactively update your layout; in order
    > to use `preset`, you will need to specify the position of each node.

    ## Physics-based Layouts

    Additionally, the `cose` layout can be used to position the nodes using
    a force-directed layout by simulating attraction and repulsion among the
    elements, based on the paper by
    [Dogrusoz et al, 2009](https://dl.acm.org/citation.cfm?id=1498047).
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-layout-9',
        elements=elements,
        style={'width': '100%', 'height': '350px'},
        layout={
            'name': 'cose'
        }
    )
    '''),

    rc.Markdown('''
    ## Loading External Layout

    > External layouts are now available! Update your `dash-cytoscape` to
    > [version 0.1.1](https://github.com/plotly/dash-cytoscape/pull/50) or later.

    The following external layouts are distributed with the official `dash-cytoscape` library:
    * [cose-bilkent](https://github.com/cytoscape/cytoscape.js-cose-bilkent)
    * [cola](https://github.com/cytoscape/cytoscape.js-cola)
    * [euler](https://github.com/cytoscape/cytoscape.js-dagre)
    * [spread](https://github.com/cytoscape/cytoscape.js-spread)
    * [dagre](https://github.com/cytoscape/cytoscape.js-dagre)
    * [klay](https://github.com/cytoscape/cytoscape.js-klay)

    In order to use them, you will need to use the `load_extra_layouts()` function from
    `dash_cytoscape`:
    '''),

    rc.Markdown('''
    ```py
    import dash
    from dash.dependencies import Input, Output, State
    import dash_core_components as dcc
    import dash_html_components as html

    import dash_cytoscape as cyto

    # Load extra layouts
    cyto.load_extra_layouts()

    app = dash.Dash(__name__)
    server = app.server
    ```
    ''', style=styles.code_container),

    rc.Markdown('''
    We also provided a
    [demo app directly derived from `usage-elements`](https://github.com/plotly/dash-cytoscape/blob/master/demos/usage-elements-extra.py),
    but with the option to use the external layouts.

    > Make sure you use external layouts only when necessary. The distribution package takes
    > almost 3x more space than the regular bundle, which means that it will take more time to
    > load your apps, especially on slower networks.
    > [This image](https://github.com/plotly/dash-cytoscape/blob/master/demos/images/fast3g-cytoscape.PNG)
    > shows how long it would take to load the dev package on a slower network.
    ''')
])
