import json
import six.moves.urllib.request as urlreq
from six import PY3

import dash
import dash_bio as dashbio
import dash_html_components as html


external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

data = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'oncoprint_dataset3.json'
).read()

if PY3:
    data = data.decode('utf-8')

data = json.loads(data)

app.layout = html.Div([
    dashbio.OncoPrint(
        id='my-dashbio-oncoprint',
        data=data
    ),
    html.Div(id='oncoprint-output')
])


@app.callback(
    dash.dependencies.Output('oncoprint-output', 'children'),
    [dash.dependencies.Input('my-dashbio-oncoprint', 'eventDatum')]
)
def update_output(event_data):
    if event_data is None or len(event_data) == 0:
        return 'There are no event data. Hover over or click on a part \
        of the graph to generate event data.'

    event_data = json.loads(event_data)

    return [
        html.Div('{}: {}'.format(
            key,
            str(event_data[key]).replace('<br>', '\n')
        ))
        for key in event_data.keys()]


if __name__ == '__main__':
    app.run_server(debug=True)
