import dash_cytoscape as cyto
import dash_core_components as dcc
import dash_html_components as html


from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

nodes = [
    {
        'data': {'id': short, 'label': label},
        'position': {'x': 20 * lat, 'y': -20 * long}
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

default_stylesheet = [
    {
        'selector': 'node',
        'style': {
            'background-color': '#BFD7B5',
            'label': 'data(label)'
        }
    },
    {
        'selector': 'edge',
        'style': {
            'line-color': '#A3C4BC'
        }
    }
]

Display = rc.CreateDisplay({
    'cyto': cyto,
    'elements': nodes + edges,
    'html': html,
    'dcc': dcc,
    'default_stylesheet': default_stylesheet,
    'nodes': nodes,
    'edges': edges
})

layout = html.Div([

    rc.Markdown('''
    # Dash Callbacks for Cytoscape

    <dccLink href="/basic-callbacks" children="Dash callbacks"/> allow you to update your
    Cytoscape graph via other components like dropdowns, buttons, and sliders.
    If you have used Cytoscape.js before, you have probably used event handlers
    to interactively update your graph; with Dash Cytoscape, we will instead
    use callbacks.

    ## Changing Layouts

    Consider the graph containing North American cities from the layout
    chapter. We have shown in that chapter how to display the same graph in
    multiple layouts. But what if we want to introduce the option for the
    user to interactively update the layouts?

    Recall the declaration of the graph:
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

    Display('''
    cyto.Cytoscape(
        id='cytoscape-callbacks-1',
        elements=elements,
        style={'width': '100%', 'height': '400px'},
        layout={
            'name': 'grid'
        }
    )
    '''),

    rc.Markdown('''
    What we want to modify is the argument to `layout`. To do so, we could use
    a `dash_core_components.Dropdown` with the name of the layouts as options.
    We could set the default value to 'grid', and force it to be unclearable
    (since we do not want to pass a dictionary with null value to `Cytoscape`).
    '''),

    Display('''
    dcc.Dropdown(
        id='dropdown-callbacks-1',
        value='grid',
        clearable=False,
        options=[
            {'label': name.capitalize(), 'value': name}
            for name in ['grid', 'random', 'circle', 'cose', 'concentric']
        ]
    )
    '''),

    rc.Markdown('''
    The construction of the callback becomes extremely easy. We simply create
    a function as such:
    '''),

    rc.Markdown('''
    ```py
    @app.callback(Output('cytoscape-callbacks-1', 'layout'),
                  [Input('dropdown-callbacks-1', 'value')])
        def update_layout(layout):
            return {'name': layout}
    ```
    ''', style=styles.code_container),

    rc.Markdown('''
    In fact, it is even possible to animate the layouts after an update!
    Simply enable `animate`:

    '''),

    rc.Markdown('''
    ```py
    @app.callback(Output('cytoscape-callbacks-1', 'layout'),
                  [Input('dropdown-callbacks-1', 'value')])
    def update_layout(layout):
        return {
            'name': layout,
            'animate': True
        }
    ```
    ''', style=styles.code_container),

    rc.Markdown('''
    Piecing everything together, we get:
    '''),

    rc.Markdown(
        examples['update_layout.py'][0],
        style=styles.code_container
    ),

    html.Div(
        examples['update_layout.py'][1],
        className='example-container'
    ),

    rc.Markdown('''
    > Notice we did not include an animation for `preset`. As discussed in the layout chapter, you
    > will need to specify the position of the nodes inside of the `layout` dictionary. Check out
    > [this example](https://github.com/plotly/dash-cytoscape/blob/master/demos/usage-preset-animation.py)
    > for more details.

    ## Interactively update styles

    Updating the stylesheet using Dash components is similar to updating
    layouts, although it can get more complex. Indeed, you can choose to create
    a default stylesheet, and append new styles to that stylesheet every time
    a designated callback is fired. Let's take the following stylesheet:

    '''),

    rc.Markdown('''
    ```py
    default_stylesheet = [
        {
            'selector': 'node',
            'style': {
                'background-color': '#BFD7B5',
                'label': 'data(label)'
            }
        },
        {
            'selector': 'edge',
            'style': {
                'line-color': '#A3C4BC'
            }
        }
    ]
    ```
    ''', style=styles.code_container),

    rc.Markdown('''

    This is generally declared at the beginning of your script, before layout
    declaration (therefore it is shared across sessions). The city graph will
    look something like this:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-callbacks-2',
        elements=elements,
        stylesheet=default_stylesheet,
        style={'width': '100%', 'height': '400px'},
        layout={
            'name': 'circle'
        }
    )
    '''),

    rc.Markdown('''
    We might want to use text fields to input the color we want to add:
    '''),

    Display('''
    html.Div([
        html.Div(style={'width': '50%', 'display': 'inline'}, children=[
            'Edge Color:',
            dcc.Input(id='input-line-color', type='text')
        ]),
        html.Div(style={'width': '50%', 'display': 'inline'}, children=[
            'Node Color:',
            dcc.Input(id='input-bg-color', type='text')
        ])
    ])
    '''),

    rc.Markdown('''
    All we need now is to assign a callback that will add new styles to the
    default stylesheet in order to change the default color:

    '''),

    rc.Markdown('''
    ```py
    @app.callback(Output('cytoscape-callbacks-2', 'stylesheet'),
              [Input('input-line-color', 'value'),
               Input('input-bg-color', 'value')])
    def update_stylesheet(line_color, bg_color):
        if line_color is None:
            line_color = ''

        if bg_color is None:
            bg_color = ''

        new_styles = [
            {
                'selector': 'node',
                'style': {
                    'background-color': bg_color
                }
            },
            {
                'selector': 'edge',
                'style': {
                    'line-color': line_color
                }
            }
        ]

        return default_stylesheet + new_styles
    ```
    ''', style=styles.code_container),

    rc.Markdown('''

    Notice that we are setting the line and background color to an empty
    string when they are set to `None`; this is to avoid feeding `None`
    to the dictionary, since it is not accepted by `Cytoscape`.

    However, passing any string value to the dictionary is accepted, even when
    the string value is not recognized. Therefore, the callback is fired every
    time you type a new character, but the changes are only applied when
    `Cytoscape` recognizes the input, which in this case could be the name of
    a color, the hex code, or the rgb function.

    Below, we show how the entire app is constructed:
    '''),

    rc.Markdown(
        examples['stylesheet_callbacks.py'][0],
        style=styles.code_container
    ),

    html.Div(
        examples['stylesheet_callbacks.py'][1],
        className='example-container'
    ),

    rc.Markdown('''
    In this example, we are not appending the new styles
    directly to the default style, but instead concatenating
    `default_stylesheet` with `new_styles`. This is because any modification
    to `default_stylesheet` will be permanent, which is not a good thing if you
    are hosting your app for many users (since `default_stylesheet` is shared
    across all user sessions).

    If you want to find more examples of styling using callbacks,
    check out the [`usage-stylesheet.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-stylesheet.py),
    example in the `dash-cytoscape` Github project. It presents a comprehensive
    overview of techniques for manipulating stylesheets in Dash Cytoscape.

    ## Adding and removing elements

    One useful aspect of callbacks is the ability to add and remove elements.
    By using elements as a state of your callback, you can decide to manipulate
    it in order to add elements whenever another Dash component is updated.

    Let's take as an example a simple app where you can add and remove nodes
    by clicking two html buttons (with the same graph as above):
    '''),

    Display('''
    html.Div([
        html.Button('Add Node', id='btn-add-node-example', n_clicks_timestamp=0),
        html.Button('Remove Node', id='btn-remove-node-example', n_clicks_timestamp=0)
    ])
    '''),

    rc.Markdown('''
    The following callback would be needed:

    '''),

    rc.Markdown('''
    ```py
    @app.callback(Output('cytoscape-callbacks-2', 'elements'),
                  [Input('btn-add-node-example', 'n_clicks_timestamp'),
                   Input('btn-remove-node-example', 'n_clicks_timestamp')],
                  [State('cytoscape-callbacks-2', 'elements')])
    def update_elements(btn_add, btn_remove, elements):
        if int(btn_add) > int(btn_remove):
            next_node_idx = len(elements) - len(edges)

            if next_node_idx < len(nodes):
                return edges + nodes[:next_node_idx+1]

        elif int(btn_remove) > int(btn_add):
            if len(elements) > len(edges):
                return elements[:-1]

        return elements
    ```
    ''', style=styles.code_container),

    rc.Markdown('''

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
    '''),

    rc.Markdown(
        examples['elements_callbacks.py'][0],
        style=styles.code_container
    ),

    html.Div(
        examples['elements_callbacks.py'][1],
        className='example-container'
    )
])
