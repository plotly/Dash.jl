import six.moves.urllib.request as urlreq
from six import PY3

import dash
import dash_bio as dashbio
import dash_html_components as html
import dash_core_components as dcc
from dash_bio_utils import xyz_reader

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

data = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'speck_methane.xyz'
).read()

if PY3:
    data = data.decode('utf-8')

data = xyz_reader.read_xyz(datapath_or_datastring=data, is_datafile=False)

app.layout = html.Div([
    dcc.Dropdown(
        id='speck-preset-views',
        options=[
            {'label': 'Default', 'value': 'default'},
            {'label': 'Ball and stick', 'value': 'stickball'}
        ],
        value='default'
    ),
    dashbio.Speck(
        id='my-speck',
        data=data
    ),
])


@app.callback(
    dash.dependencies.Output('my-speck', 'presetView'),
    [dash.dependencies.Input('speck-preset-views', 'value')]
)
def update_preset_view(preset_name):
    return preset_name


if __name__ == '__main__':
    app.run_server(debug=True)
