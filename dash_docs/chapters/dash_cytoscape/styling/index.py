import dash_cytoscape as cyto
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import tools
from dash_docs import styles
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

simple_elements = [
    {
        'data': {'id': 'one', 'label': 'Modified Color'},
        'position': {'x': 75, 'y': 75},
        'classes': 'red'  # Single class
    },
    {
        'data': {'id': 'two', 'label': 'Modified Shape'},
        'position': {'x': 75, 'y': 200},
        'classes': 'triangle'  # Single class
    },
    {
        'data': {'id': 'three', 'label': 'Both Modified'},
        'position': {'x': 200, 'y': 75},
        'classes': 'red triangle'  # Multiple classes
    },
    {
        'data': {'id': 'four', 'label': 'Regular'},
        'position': {'x': 200, 'y': 200}
    },
    {'data': {'source': 'one', 'target': 'two'}, 'classes': 'red'},
    {'data': {'source': 'two', 'target': 'three'}},
    {'data': {'source': 'three', 'target': 'four'}, 'classes': 'red'},
    {'data': {'source': 'two', 'target': 'four'}},
]

weighted_elements = [
    {'data': {'id': 'A'}},
    {'data': {'id': 'B'}},
    {'data': {'id': 'C'}},
    {'data': {'id': 'D'}},
    {'data': {'id': 'E'}},

    {'data': {'source': 'A', 'target': 'B', 'weight': 1}},
    {'data': {'source': 'A', 'target': 'C', 'weight': 2}},
    {'data': {'source': 'B', 'target': 'D', 'weight': 3}},
    {'data': {'source': 'B', 'target': 'E', 'weight': 4}},
    {'data': {'source': 'C', 'target': 'E', 'weight': 5}},
    {'data': {'source': 'D', 'target': 'A', 'weight': 6}}
]

named_elements = [
    {'data': {'id': 'A', 'firstname': 'Albert'}},
    {'data': {'id': 'B', 'firstname': 'Bert'}},
    {'data': {'id': 'C', 'firstname': 'Charlie'}},
    {'data': {'id': 'D', 'firstname': 'Daniela'}},
    {'data': {'id': 'E', 'firstname': 'Emma'}},

    {'data': {'source': 'A', 'target': 'B', 'weight': 1}},
    {'data': {'source': 'A', 'target': 'C', 'weight': 2}},
    {'data': {'source': 'B', 'target': 'D', 'weight': 3}},
    {'data': {'source': 'B', 'target': 'E', 'weight': 4}},
    {'data': {'source': 'C', 'target': 'E', 'weight': 5}},
    {'data': {'source': 'D', 'target': 'A', 'weight': 6}}
]


double_edges = [
    {'data': {'id': src+tgt, 'source': src, 'target': tgt}}
    for src, tgt in ['AB', 'BA', 'BC', 'CB', 'CD', 'DC', 'DA', 'AD']
]

double_edged_el = [{'data': {'id': id_}} for id_ in 'ABCD'] + double_edges


directed_edges = [
    {'data': {'id': src+tgt, 'source': src, 'target': tgt}}
    for src, tgt in ['BA', 'BC', 'CD', 'DA']
]

directed_elements = [{'data': {'id': id_}} for id_ in 'ABCD'] + directed_edges


Display = rc.CreateDisplay({
    'cyto': cyto,
    'simple_elements': simple_elements,
    'weighted_elements': weighted_elements,
    'named_elements': named_elements,
    'double_edged_el': double_edged_el,
    'directed_elements': directed_elements
})


layout = html.Div([

    rc.Markdown('''
    # Cytoscape Styling

    ## The `stylesheet` parameter

    Just like how the `elements` parameter takes as an input a list of
    dictionaries specifying all the elements in the graph, the stylesheet takes
    a list of dictionaries specifying the style for a group of elements, a
    class of elements, or a single element. Each of these dictionaries accept
    two keys:
    - `'selector'`: A string indicating which elements you are styling.
    - `'style'`: A dictionary specifying what exactly you want to modify. This
    could be the width, height, color of a node, the shape of the arrow on an
    edge, or many more.

    Both [the selector string](http://js.cytoscape.org/#selectors) and
    [the style dictionary](http://js.cytoscape.org/#style/node-body) are
    exhaustively documented in the Cytoscape.js docs. We will show examples
    that can be easily modified for any type of design, and you can create
    your own styles with the [online style editor](https://dash-gallery.plotly.host/cytoscape-advanced)
    (which you can use locally by running [`usage-advanced.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-advanced.py).

    ## Basic selectors and styles

    We start by looking at the same example shown in the elements
    chapter, but this time we examine the stylesheet:
    '''),

    html.Details(open=False, children=[
        html.Summary('View simple elements'),
        rc.Markdown('''
        ```py
        simple_elements = [
            {
                'data': {'id': 'one', 'label': 'Modified Color'},
                'position': {'x': 75, 'y': 75},
                'classes': 'red' # Single class
            },
            {
                'data': {'id': 'two', 'label': 'Modified Shape'},
                'position': {'x': 75, 'y': 200},
                'classes': 'triangle' # Single class
            },
            {
                'data': {'id': 'three', 'label': 'Both Modified'},
                'position': {'x': 200, 'y': 75},
                'classes': 'red triangle' # Multiple classes
            },
            {
                'data': {'id': 'four', 'label': 'Regular'},
                'position': {'x': 200, 'y': 200}
            },
            {'data': {'source': 'one', 'target': 'two'}, 'classes': 'red'},
            {'data': {'source': 'two', 'target': 'three'}},
            {'data': {'source': 'three', 'target': 'four'}, 'classes': 'red'},
            {'data': {'source': 'two', 'target': 'four'}},
        ]
        ```
        ''', style=styles.code_container),
    ]),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-styling-1',
        layout={'name': 'preset'},
        style={'width': '100%', 'height': '400px'},
        elements=simple_elements,
        stylesheet=[
            # Group selectors
            {
                'selector': 'node',
                'style': {
                    'content': 'data(label)'
                }
            },

            # Class selectors
            {
                'selector': '.red',
                'style': {
                    'background-color': 'red',
                    'line-color': 'red'
                }
            },
            {
                'selector': '.triangle',
                'style': {
                    'shape': 'triangle'
                }
            }
        ]
    )
    '''),

    rc.Markdown('''
    In this example, we use the group and class selectors. Group selectors
    consist of either the string `'node'` or the string `'edge'`, since an
    element can only be one or the other.

    To select a class, you simply pass `.className` to the selector, where
    `className` is the name of one of the classes you assigned to some of your
    elements. Notice in the example above that if an element has two or more
    classes, it will accept all the styles that select it.

    Here, we are simultaneously modifying the background and line color of all
    the elements of class "red". This means that if the element is a node, then
    it will be filled with red, and it is an edge, then the color of the line
    will be red. Although this offers great flexibility, you need to be careful
    with your declaration, since you won't receive warning if you use the wrong
    key or make a typo. Standard RGB and Hex colors are accepted, along with
    basic colors recognized by CSS.

    Additionally, the `content` key takes as value what you want to display
    above or next to the element on the screen, which in this case is the
    label inside the `data` dictionary of the input element. Since we defined
    a label for each element, that label will be displayed for every node.

    ## Comparing data items using selectors

    A nice property of the selector is that it can select elements by comparing
    a certain item of the data dictionaries with a given value. Say we have
    some nodes with `id` A to E declared this way:
    ```py
    {'data': {'source': 'A', 'target': 'B', 'weight': 1}}
    ```
    where the `'weight'` key indicates the weight of your edge. You can find
    the declaration below:

    '''),

    html.Details(open=False, children=[
        html.Summary('View weighted elements'),
        rc.Markdown('''
        ```py
        weighted_elements = [
            {'data': {'id': 'A'}},
            {'data': {'id': 'B'}},
            {'data': {'id': 'C'}},
            {'data': {'id': 'D'}},
            {'data': {'id': 'E'}},

            {'data': {'source': 'A', 'target': 'B', 'weight': 1}},
            {'data': {'source': 'A', 'target': 'C', 'weight': 2}},
            {'data': {'source': 'B', 'target': 'D', 'weight': 3}},
            {'data': {'source': 'B', 'target': 'E', 'weight': 4}},
            {'data': {'source': 'C', 'target': 'E', 'weight': 5}},
            {'data': {'source': 'D', 'target': 'A', 'weight': 6}}
        ]
        ```
        ''', style=styles.code_container),
    ]),

    rc.Markdown('''
    If you want to highlight all the of the edges above a certain weight
    (e.g. 3), use the selector `'[weight > 3]'`. For example:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-styling-2',
        layout={'name': 'circle'},
        style={'width': '100%', 'height': '400px'},
        elements=weighted_elements,
        stylesheet=[
            {
                'selector': 'edge',
                'style': {
                    'label': 'data(weight)'
                }
            },
            {
                'selector': '[weight > 3]',
                'style': {
                    'line-color': 'blue'
                }
            }
        ]
    )
    '''),

    rc.Markdown('''
    Similarly, if you want to have weights smaller or equal to 3, you would
    write:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-styling-3',
        layout={'name': 'circle'},
        style={'width': '100%', 'height': '400px'},
        elements=weighted_elements,
        stylesheet=[
            {
                'selector': 'edge',
                'style': {
                    'label': 'data(weight)'
                }
            },
            {
                'selector': '[weight <= 3]',
                'style': {
                    'line-color': 'blue'
                }
            }
        ]
    )
    '''),

    rc.Markdown('''
    Comparisons also work for string matching problems. Given the same graph
    as before, but with a data key `'firstname'` for each node:
    ```py
    {'data': {'id': 'A', 'firstname': 'Albert'}}
    ```
    We can select all the elements that match a specific pattern. For instance,
    to style nodes where `'firstname'` contains the substring `'ert'`, we
    declare:
    '''),

    html.Details(open=False, children=[
        html.Summary('View named elements'),
        rc.Markdown('''
        ```py
        named_elements = [
            {'data': {'id': 'A', 'firstname': 'Albert'}},
            {'data': {'id': 'B', 'firstname': 'Bert'}},
            {'data': {'id': 'C', 'firstname': 'Charlie'}},
            {'data': {'id': 'D', 'firstname': 'Daniela'}},
            {'data': {'id': 'E', 'firstname': 'Emma'}},

            {'data': {'source': 'A', 'target': 'B'}},
            {'data': {'source': 'A', 'target': 'C'}},
            {'data': {'source': 'B', 'target': 'D'}},
            {'data': {'source': 'B', 'target': 'E'}},
            {'data': {'source': 'C', 'target': 'E'}},
            {'data': {'source': 'D', 'target': 'A'}}
        ]
        ```
        ''', style=styles.code_container),
    ]),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-styling-4',
        layout={'name': 'circle'},
        style={'width': '100%', 'height': '400px'},
        elements=named_elements,
        stylesheet=[
            {
                'selector': 'node',
                'style': {
                    'label': 'data(firstname)'
                }
            },
            {
                'selector': '[firstname *= "ert"]',
                'style': {
                    'background-color': '#FF4136',
                    'shape': 'rectangle'
                }
            }
        ]
    )
    '''),

    rc.Markdown('''
    Now, if we want to select all the elements where `'firstname'` *does not*
    contain `'ert'`, then we can run:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-styling-5',
        layout={'name': 'circle'},
        style={'width': '100%', 'height': '400px'},
        elements=named_elements,
        stylesheet=[
            {
                'selector': 'node',
                'style': {
                    'label': 'data(firstname)'
                }
            },
            {
                'selector': '[firstname !*= "ert"]',
                'style': {
                    'background-color': '#FF4136',
                    'shape': 'rectangle'
                }
            }
        ]
    )
    '''),

    rc.Markdown('''
    Other options also exist for matching specific parts of the string. For
    example, if we want to only select the prefix, we can use `^=` as such:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-styling-6',
        layout={'name': 'circle'},
        style={'width': '100%', 'height': '400px'},
        elements=named_elements,
        stylesheet=[
            {
                'selector': 'node',
                'style': {
                    'label': 'data(firstname)'
                }
            },
            {
                'selector': '[firstname ^= "Alb"]',
                'style': {
                    'background-color': '#FF4136',
                    'shape': 'rectangle'
                }
            }
        ]
    )
    '''),

    rc.Markdown('''
    This can also be prepended by modifiers. For example, `@` added in front
    of an operator will render the string matched case insensitive.
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-styling-7',
        layout={'name': 'circle'},
        style={'width': '100%', 'height': '400px'},
        elements=named_elements,
        stylesheet=[
            {
                'selector': 'node',
                'style': {
                    'label': 'data(firstname)'
                }
            },
            {
                'selector': '[firstname @^= "alb"]',
                'style': {
                    'background-color': '#FF4136',
                    'shape': 'rectangle'
                }
            }
        ]
    )
    '''),

    rc.Markdown('''
    View the [complete list of matching operations](http://js.cytoscape.org/#selectors/data)
     for data selectors.

    ## Styling edges

    ### Two-sided edges and curvature

    Many methods exist to style edges in Dash Cytoscape. In some cases, you
    might want different ways to display double-edged
    '''),

    html.Details(open=False, children=[
        html.Summary('View double-edged elements'),
        rc.Markdown('''
        ```py
        double_edges = [
            {'data': {'id': src+tgt, 'source': src, 'target': tgt}}
            for src, tgt in ['AB', 'BA', 'BC', 'CB', 'CD', 'DC', 'DA', 'AD']
        ]

        double_edged_el = [{'data': {'id': id_}} for id_ in 'ABCD'] + double_edges
        ```
        ''', style=styles.code_container),
    ]),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-styling-8',
        layout={'name': 'circle'},
        style={'width': '100%', 'height': '400px'},
        elements=double_edged_el,
        stylesheet=[
            {
                'selector': 'node',
                'style': {
                    'label': 'data(id)'
                }
            },
            {
                'selector': '#AB, #BA',
                'style': {
                    'curve-style': 'bezier',
                    'label': 'bezier',
                    'line-color': 'red'
                }
            },
            {
                'selector': '#AD, #DA',
                'style': {
                    'curve-style': 'haystack',
                    'label': 'haystack',
                    'line-color': 'blue'
                }
            },
            {
                'selector': '#DC, #CD',
                'style': {
                    'curve-style': 'segments',
                    'label': 'segments',
                    'line-color': 'green'
                }
            }
        ]
    )
    '''),

    rc.Markdown('''
    Many curve styles are accepted, and support further customization such as
    the distance between edges and curvature radius. You can find them in
    the [JavaScript docs](http://js.cytoscape.org/#style/bezier-edges).

    ### Edge Arrows

    To better highlight the directed edges, we can add arrows of different
    shapes, colors, and positions onto the edges. This is an example of using
    different types of arrows, with the same graph above, but with certain
    edges removed:
    '''),

    html.Details(open=False, children=[
        html.Summary('View directed elements'),
        rc.Markdown('''
        ```py
        directed_edges = [
            {'data': {'id': src+tgt, 'source': src, 'target': tgt}}
            for src, tgt in ['BA', 'BC', 'CD', 'DA']
        ]

        directed_elements = [{'data': {'id': id_}} for id_ in 'ABCD'] + directed_edges
        ```
        ''', style=styles.code_container),
    ]),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-styling-9',
        layout={'name': 'circle'},
        style={'width': '100%', 'height': '400px'},
        elements=directed_elements,
        stylesheet=[
            {
                'selector': 'node',
                'style': {
                    'label': 'data(id)'
                }
            },
            {
                'selector': 'edge',
                'style': {
                    # The default curve style does not work with certain arrows
                    'curve-style': 'bezier'
                }
            },
            {
                'selector': '#BA',
                'style': {
                    'source-arrow-color': 'red',
                    'source-arrow-shape': 'triangle',
                    'line-color': 'red'
                }
            },
            {
                'selector': '#DA',
                'style': {
                    'target-arrow-color': 'blue',
                    'target-arrow-shape': 'vee',
                    'line-color': 'blue'
                }
            },
            {
                'selector': '#BC',
                'style': {
                    'mid-source-arrow-color': 'green',
                    'mid-source-arrow-shape': 'diamond',
                    'mid-source-arrow-fill': 'hollow',
                    'line-color': 'green',
                }
            },
            {
                'selector': '#CD',
                'style': {
                    'mid-target-arrow-color': 'black',
                    'mid-target-arrow-shape': 'circle',
                    'arrow-scale': 2,
                    'line-color': 'black',
                }
            }
        ]
    )
    '''),

    rc.Markdown('''
    Notice here that we prepend a position indicator for the color and shape
    keys. In the previous example, all four possible positions are displayed.
    In fact, you can even the edges with multiple arrows, all with different
    colors and shapes. View the [complete list of edge arrow configurations](http://js.cytoscape.org/#style/edge-arrow).


    ## Displaying Images

    It is possible to [display images inside nodes](http://js.cytoscape.org/#style/background-image),
    as documented in Cytoscape.js. We show below a complete example of display
    an interactive tree of animal phylogeny using images from Wikimedia.
    '''),

    rc.Markdown(
        examples['images.py'][0],
        style=styles.code_container
    ),

    html.Div(
        examples['images.py'][1],
        className='example-container'
    )
])
