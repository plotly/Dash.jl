import dash
import dash_cytoscape as cyto
import dash_html_components as html
import dash_core_components as dcc
from pprint import pprint
from dash.dependencies import Input, Output, State

app = dash.Dash(__name__)


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


app.layout = html.Div([
    html.Div([
        html.Button('Add Node', id='btn-add-node', n_clicks_timestamp=0),
        html.Button('Remove Node', id='btn-remove-node', n_clicks_timestamp=0)
    ]),

    cyto.Cytoscape(
        id='cytoscape-elements-callbacks',
        layout={'name': 'circle'},
        stylesheet=default_stylesheet,
        style={'width': '100%', 'height': '450px'},
        elements=edges+nodes
    )
])


@app.callback(Output('cytoscape-elements-callbacks', 'elements'),
              [Input('btn-add-node', 'n_clicks_timestamp'),
               Input('btn-remove-node', 'n_clicks_timestamp')],
              [State('cytoscape-elements-callbacks', 'elements')])
def update_elements(btn_add, btn_remove, elements):
    # If the add button was clicked most recently
    if int(btn_add) > int(btn_remove):
        next_node_idx = len(elements) - len(edges)

        # As long as we have not reached the max number of nodes, we add them
        # to the cytoscape elements
        if next_node_idx < len(nodes):
            return edges + nodes[:next_node_idx+1]

    # If the remove button was clicked most recently
    elif int(btn_remove) > int(btn_add):
        if len(elements) > len(edges):
            return elements[:-1]

    # Neither have been clicked yet (or fallback condition)
    return elements


if __name__ == '__main__':
    app.run_server(debug=True)
