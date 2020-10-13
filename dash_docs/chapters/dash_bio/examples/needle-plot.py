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
    'needle_PIK3CA.json'
).read()

if PY3:
    data = data.decode('utf-8')

mdata = json.loads(data)

app.layout = html.Div([
    "Show or hide range slider",
    dcc.Dropdown(
        id='needleplot-rangeslider',
        options=[
            {'label': 'Show', 'value': 1},
            {'label': 'Hide', 'value': 0}
        ],
        clearable=False,
        multi=False,
        value=1
    ),
    dashbio.NeedlePlot(
        id='my-dashbio-needleplot',
        mutationData=mdata
    )
])


@app.callback(
    dash.dependencies.Output('my-dashbio-needleplot', 'rangeSlider'),
    [dash.dependencies.Input('needleplot-rangeslider', 'value')]
)
def update_needleplot(show_rangeslider):
    return True if show_rangeslider else False


if __name__ == '__main__':
    app.run_server(debug=True)
