import dash
import dash_cytoscape as cyto
import dash_html_components as html
import dash_core_components as dcc
from dash.dependencies import Input, Output

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

elements = nodes + edges


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
        html.Div(style={'width': '50%', 'display': 'inline'}, children=[
            'Edge Color:',
            dcc.Input(id='input-line-color', type='text')
        ]),
        html.Div(style={'width': '50%', 'display': 'inline'}, children=[
            'Node Color:',
            dcc.Input(id='input-bg-color', type='text')
        ])
    ]),

    cyto.Cytoscape(
        id='cytoscape-stylesheet-callbacks',
        layout={'name': 'circle'},
        stylesheet=default_stylesheet,
        style={'width': '100%', 'height': '450px'},
        elements=elements
    )
])


@app.callback(Output('cytoscape-stylesheet-callbacks', 'stylesheet'),
              [Input('input-line-color', 'value'),
               Input('input-bg-color', 'value')])
def update_stylesheet(line_color, bg_color):
    if line_color is None:
        line_color = 'transparent'

    if bg_color is None:
        bg_color = 'transparent'

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


if __name__ == '__main__':
    app.run_server(debug=True)
