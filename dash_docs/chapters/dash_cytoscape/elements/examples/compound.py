import dash
import dash_cytoscape as cyto
import dash_html_components as html

app = dash.Dash(__name__)

app.layout = html.Div([
    cyto.Cytoscape(
        id='cytoscape-compound',
        layout={'name': 'preset'},
        style={'width': '100%', 'height': '450px'},
        stylesheet=[
            {
                'selector': 'node',
                'style': {'content': 'data(label)'}
            },
            {
                'selector': '.countries',
                'style': {'width': 5}
            },
            {
                'selector': '.cities',
                'style': {'line-style': 'dashed'}
            }
        ],
        elements=[
            # Parent Nodes
            {
                'data': {'id': 'us', 'label': 'United States'}
            },
            {
                'data': {'id': 'can', 'label': 'Canada'}
            },

            # Children Nodes
            {
                'data': {'id': 'nyc', 'label': 'New York', 'parent': 'us'},
                'position': {'x': 100, 'y': 100}
            },
            {
                'data': {'id': 'sf', 'label': 'San Francisco', 'parent': 'us'},
                'position': {'x': 100, 'y': 200}
            },
            {
                'data': {'id': 'mtl', 'label': 'Montreal', 'parent': 'can'},
                'position': {'x': 400, 'y': 100}
            },

            # Edges
            {
                'data': {'source': 'can', 'target': 'us'},
                'classes': 'countries'
            },
            {
                'data': {'source': 'nyc', 'target': 'sf'},
                'classes': 'cities'
            },
            {
                'data': {'source': 'sf', 'target': 'mtl'},
                'classes': 'cities'
            }
        ]
    )
])

if __name__ == '__main__':
    app.run_server(debug=True)
