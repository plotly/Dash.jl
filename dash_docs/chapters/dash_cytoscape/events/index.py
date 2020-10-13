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
    'html': html,
    'dcc': dcc,
    'default_stylesheet': default_stylesheet,
    'nodes': nodes,
    'edges': edges
})

layout = html.Div([

    rc.Markdown('''
    # Cytoscape Event Callbacks

    In <dccLink href="/cytoscape/callbacks" children="part 4"/>, we showed how to update Cytoscape with
    other components by assigning callbacks that output to `'elements',
    'stylesheet', 'layout'`. Moreover, it is also possible to use properties
    of Cytoscape as an input to callbacks, which can be used to update other
    components, or Cytoscape itself. Those properties are updated (which fires
    the callbacks) when the user interact with elements in a certain way,
    which justifies the name of event callbacks. You can find props such as
    `tapNode`, which returns a complete description of the node object when
    the user clicks or taps on a node, `mouseoverEdgeData`, which returns only
    the data dictionary of the edge that was most recently hovered by the user.
    The complete list can be found in the <dccLink href="/cytoscape/reference" children="Dash Cytoscape Reference"/>.

    ## Simple callback construction

    Let's look back at the same city example as the previous chapter:
    '''),

    Display('''
    cyto.Cytoscape(
        id='cytoscape-events',
        layout={'name': 'preset'},
        elements=edges+nodes,
        stylesheet=default_stylesheet,
        style={'width': '100%', 'height': '450px'}
    )
    '''),

    rc.Markdown('''
    This time, we will use the `tapNodeData` properties as input
    to our callbacks, which will simply dump the content into an `html.Pre`:
    '''),

    rc.Markdown(
        examples['event_callbacks.py'][0],
        style=styles.code_container
    ),

    html.Div(
        examples['event_callbacks.py'][1],
        className='example-container'
    ),

    rc.Markdown('''
    Notice that the `html.Div` is updated every time you click or tap a node,
    and returns the data dictionary of the node. Alternatively, you can use
    `tapNode` to obtain the entire element specification (given as a
    dictionary), rather than just its `data`.

    ## Click, tap and hover

    Let's now display the data generated whenever you click or hover over a node
    or an edge. Simply replace the previous layout and callbacks by this:
    '''),

    rc.Markdown('''
    ```py
        app.layout = html.Div([
            cyto.Cytoscape(
                id='cytoscape-event-callbacks-2',
                layout={'name': 'preset'},
                elements=edges+nodes,
                stylesheet=default_stylesheet,
                style={'width': '100%', 'height': '450px'}
            ),
            html.P(id='cytoscape-tapNodeData-output'),
            html.P(id='cytoscape-tapEdgeData-output'),
            html.P(id='cytoscape-mouseoverNodeData-output'),
            html.P(id='cytoscape-mouseoverEdgeData-output')
        ])


        @app.callback(Output('cytoscape-tapNodeData-output', 'children'),
                      [Input('cytoscape-event-callbacks-2', 'tapNodeData')])
        def displayTapNodeData(data):
            if data:
                return "You recently clicked/tapped the city: " + data['label']


        @app.callback(Output('cytoscape-tapEdgeData-output', 'children'),
                      [Input('cytoscape-event-callbacks-2', 'tapEdgeData')])
        def displayTapEdgeData(data):
            if data:
                return "You recently clicked/tapped the edge between " + data['source'].upper() + " and " + data['target'].upper()


        @app.callback(Output('cytoscape-mouseoverNodeData-output', 'children'),
                      [Input('cytoscape-event-callbacks-2', 'mouseoverNodeData')])
        def displayTapNodeData(data):
            if data:
                return "You recently hovered over the city: " + data['label']


        @app.callback(Output('cytoscape-mouseoverEdgeData-output', 'children'),
                      [Input('cytoscape-event-callbacks-2', 'mouseoverEdgeData')])
        def displayTapEdgeData(data):
            if data:
                return "You recently hovered over the edge between " + data['source'].upper() + " and " + data['target'].upper()
    ```
    ''', style=styles.code_container),

    html.Div(
        examples['event_callbacks_2.py'][1],
        className='example-container'
    ),

    rc.Markdown('''

    ## Selecting multiple elements

    Additionally, you can also display all the data currently selected, either
    through a box selection (Shift+Click and drag) or by individually selecting
    multiple elements while holding Shift:
    '''),

    rc.Markdown('''
    ```py
        app.layout = html.Div([
            cyto.Cytoscape(
                id='cytoscape-event-callbacks-3',
                layout={'name': 'preset'},
                elements=edges+nodes,
                stylesheet=default_stylesheet,
                style={'width': '100%', 'height': '450px'}
            ),
            rc.Markdown(id='cytoscape-selectedNodeData-markdown')
        ])


        @app.callback(Output('cytoscape-selectedNodeData-markdown', 'children'),
                      [Input('cytoscape-event-callbacks-3', 'selectedNodeData')])
        def displaySelectedNodeData(data_list):
            if not data_list:
                return

            cities_list = [data['label'] for data in data_list]
            return "You selected the following cities: " + "\\n* ".join(cities_list)
    ```
    ''', style=styles.code_container),

    html.Div(
        examples['event_callbacks_3.py'][1],
        className='example-container'
    ),

    rc.Markdown('''
    ## Advanced usage of callbacks

    Those event callbacks enable more advanced interactions between components.
    In fact, you can even use them to update other `Cytoscape` arguments. The
    [`usage-stylesheet.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-stylesheet.py)
    example (hosted on the `dash-cytoscape` Github repo) lets you click to change the
    color of a node to purple, its targeted
    nodes to red, and its incoming nodes to blue. All of this is done using a
    single callback function, which takes as input the `tapNode` prop of the
    `Cytoscape` component along with a few dropdowns, and outputs to the
    `stylesheet` prop. You can try out this
    [interactive stylesheet demo](https://dash-gallery.plotly.host/cytoscape-stylesheet)
    hosted on [Dash Enterprise](https://plotly.com/products/dash/).
    '''),

    html.Details(open=False, children=[
        html.Summary('Expand to see how to interactively style your elements'),
        rc.Markdown('''
        ```py
        @app.callback(Output('cytoscape', 'stylesheet'),
                      [Input('cytoscape', 'tapNode'),
                       Input('input-follower-color', 'value'),
                       Input('input-following-color', 'value'),
                       Input('dropdown-node-shape', 'value')])
        def generate_stylesheet(node, follower_color, following_color, node_shape):
            if not node:
                return default_stylesheet

            stylesheet = [{
                "selector": 'node',
                'style': {
                    'opacity': 0.3,
                    'shape': node_shape
                }
            }, {
                'selector': 'edge',
                'style': {
                    'opacity': 0.2,
                    "curve-style": "bezier",
                }
            }, {
                "selector": 'node[id = "{}"]'.format(node['data']['id']),
                "style": {
                    'background-color': '#B10DC9',
                    "border-color": "purple",
                    "border-width": 2,
                    "border-opacity": 1,
                    "opacity": 1,

                    "label": "data(label)",
                    "color": "#B10DC9",
                    "text-opacity": 1,
                    "font-size": 12,
                    'z-index': 9999
                }
            }]

            for edge in node['edgesData']:
                if edge['source'] == node['data']['id']:
                    stylesheet.append({
                        "selector": 'node[id = "{}"]'.format(edge['target']),
                        "style": {
                            'background-color': following_color,
                            'opacity': 0.9
                        }
                    })
                    stylesheet.append({
                        "selector": 'edge[id= "{}"]'.format(edge['id']),
                        "style": {
                            "mid-target-arrow-color": following_color,
                            "mid-target-arrow-shape": "vee",
                            "line-color": following_color,
                            'opacity': 0.9,
                            'z-index': 5000
                        }
                    })

                if edge['target'] == node['data']['id']:
                    stylesheet.append({
                        "selector": 'node[id = "{}"]'.format(edge['source']),
                        "style": {
                            'background-color': follower_color,
                            'opacity': 0.9,
                            'z-index': 9999
                        }
                    })
                    stylesheet.append({
                        "selector": 'edge[id= "{}"]'.format(edge['id']),
                        "style": {
                            "mid-target-arrow-color": follower_color,
                            "mid-target-arrow-shape": "vee",
                            "line-color": follower_color,
                            'opacity': 1,
                            'z-index': 5000
                        }
                    })

            return stylesheet
        ```
        ''', style=styles.code_container),
    ]),

    rc.Markdown('''
    Additionally, [`usage-elements.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-elements.py)
    lets you progressively expand your graph
    by using `tapNodeData` as the input and `elements` as the output.

    The app initially pre-loads the entire dataset, but only loads the graph
    with a single node. It then constructs four dictionaries that maps every
    single node ID to its following nodes, following edges, followers nodes,
    followers edges.

    Then, it lets you expand the incoming or the outgoing
    neighbors by clicking the node you want to expand. This
    is done through a callback that retrieves the followers (outgoing) or following
    (incoming) from the dictionaries, and add the to the `elements`.
    [Click here for the online demo](https://dash-gallery.plotly.host/cytoscape-elements).
    '''),


    html.Details(open=False, children=[
        html.Summary('Expand to see how to construct the dictionaries'),
        rc.Markdown('''
        ```py
        with open('demos/data/sample_network.txt', 'r') as f:
            data = f.read().split('\\n')

        # We select the first 750 edges and associated nodes for an easier visualization
        edges = data[:750]
        nodes = set()

        following_node_di = {}  # user id -> list of users they are following
        following_edges_di = {}  # user id -> list of cy edges starting from user id

        followers_node_di = {}  # user id -> list of followers (cy_node format)
        followers_edges_di = {}  # user id -> list of cy edges ending at user id

        cy_edges = []
        cy_nodes = []

        for edge in edges:
            if " " not in edge:
                continue

            source, target = edge.split(" ")

            cy_edge = {'data': {'id': source+target, 'source': source, 'target': target}}
            cy_target = {"data": {"id": target, "label": "User #" + str(target[-5:])}}
            cy_source = {"data": {"id": source, "label": "User #" + str(source[-5:])}}

            if source not in nodes:
                nodes.add(source)
                cy_nodes.append(cy_source)
            if target not in nodes:
                nodes.add(target)
                cy_nodes.append(cy_target)

            # Process dictionary of following
            if not following_node_di.get(source):
                following_node_di[source] = []
            if not following_edges_di.get(source):
                following_edges_di[source] = []

            following_node_di[source].append(cy_target)
            following_edges_di[source].append(cy_edge)

            # Process dictionary of followers
            if not followers_node_di.get(target):
                followers_node_di[target] = []
            if not followers_edges_di.get(target):
                followers_edges_di[target] = []

            followers_node_di[target].append(cy_source)
            followers_edges_di[target].append(cy_edge)
        ```
        ''', style=styles.code_container),
    ]),

    html.Details(open=False, children=[
        html.Summary('Expand to see how to generate elements'),
        rc.Markdown('''
        ```py
        @app.callback(Output('cytoscape', 'elements'),
                      [Input('cytoscape', 'tapNodeData')],
                      [State('cytoscape', 'elements'),
                       State('radio-expand', 'value')])
        def generate_elements(nodeData, elements, expansion_mode):
            if not nodeData:
                return default_elements

            # If the node has already been expanded, we don't expand it again
            if nodeData.get('expanded'):
                return elements

            # This retrieves the currently selected element, and tag it as expanded
            for element in elements:
                if nodeData['id'] == element.get('data').get('id'):
                    element['data']['expanded'] = True
                    break

            if expansion_mode == 'followers':

                followers_nodes = followers_node_di.get(nodeData['id'])
                followers_edges = followers_edges_di.get(nodeData['id'])

                if followers_nodes:
                    for node in followers_nodes:
                        node['classes'] = 'followerNode'
                    elements.extend(followers_nodes)

                if followers_edges:
                    for edge in followers_edges:
                        edge['classes'] = 'followerEdge'
                    elements.extend(followers_edges)

            elif expansion_mode == 'following':

                following_nodes = following_node_di.get(nodeData['id'])
                following_edges = following_edges_di.get(nodeData['id'])

                if following_nodes:
                    for node in following_nodes:
                        if node['data']['id'] != genesis_node['data']['id']:
                            node['classes'] = 'followingNode'
                            elements.append(node)

                if following_edges:
                    for edge in following_edges:
                        edge['classes'] = 'followingEdge'
                    elements.extend(following_edges)

            return elements
        ```
        ''', style=styles.code_container),
    ]),

    rc.Markdown('''
    To see more examples of events, check out the [event callbacks demo](https://dash-gallery.plotly.host/cytoscape-events)
    (the source file is available as [`usage-events.py`](https://github.com/plotly/dash-cytoscape/blob/master/usage-events.py) on the project repo)
    and the <dccLink href="/cytoscape/reference" children="Cytoscape references"/>.
    ''')

])
