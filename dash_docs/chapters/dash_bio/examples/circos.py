import json
import six.moves.urllib.request as urlreq
from six import PY3

import dash
import dash_bio as dashbio
import dash_html_components as html
import dash_core_components as dcc


external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

data = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'circos_graph_data.json'
).read()

if PY3:
    data = data.decode('utf-8')

circos_graph_data = json.loads(data)

app.layout = html.Div([
    dashbio.Circos(
        id='my-dashbio-circos',
        layout=circos_graph_data['GRCh37'],
        selectEvent={"0": "hover", "1": "click", "2": "both"},
        tracks=[{
            'type': 'CHORDS',
            'data': circos_graph_data['chords'],
            'config': {
                'tooltipContent': {
                    'source': 'source',
                    'sourceID': 'id',
                    'target': 'target',
                    'targetID': 'id',
                    'targetEnd': 'end'
                }
            }
        }]
    ),
    "Graph type:",
    dcc.Dropdown(
        id='histogram-chords',
        options=[
            {'label': x, 'value': x}
            for x in ['histogram', 'chords']
        ],
        value='chords'
    ),
    "Event data:",
    html.Div(id='circos-output')
])


@app.callback(
    dash.dependencies.Output('circos-output', 'children'),
    [dash.dependencies.Input('my-dashbio-circos', 'eventDatum')]
)
def update_output(value):
    if value is not None:
        return [html.Div('{}: {}'.format(v.title(), value[v]))
                for v in value.keys()]
    return 'There are no event data. Click or hover on a data point to get more information.'


@app.callback(
    dash.dependencies.Output('my-dashbio-circos', 'tracks'),
    [dash.dependencies.Input('histogram-chords', 'value')],
    state=[dash.dependencies.State('my-dashbio-circos', 'tracks')]
)
def change_graph_type(value, current):

    if value == 'histogram':

        current[0].update(
            data=circos_graph_data['histogram'],
            type='HISTOGRAM'
        )

    elif value == 'chords':
        current[0].update(
            data=circos_graph_data['chords'],
            type='CHORDS',
            config={
                'tooltipContent': {
                    'source': 'source',
                    'sourceID': 'id',
                    'target': 'target',
                    'targetID': 'id',
                    'targetEnd': 'end'
                }
            }
        )
    return current


if __name__ == '__main__':
    app.run_server(debug=True)
