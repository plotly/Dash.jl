import json
import six.moves.urllib.request as urlreq
from six import PY3

import dash
import dash_bio as dashbio
import dash_html_components as html


external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

model_data = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'mol2d_buckminsterfullerene.json'
).read()

if PY3:
    model_data = model_data.decode('utf-8')

model_data = json.loads(model_data)

app.layout = html.Div([
    dashbio.Molecule2dViewer(
        id='my-dashbio-molecule2d',
        modelData=model_data
    ),
    html.Hr(),
    html.Div(id='molecule2d-output')
])


@app.callback(
    dash.dependencies.Output('molecule2d-output', 'children'),
    [dash.dependencies.Input('my-dashbio-molecule2d', 'selectedAtomIds')]
)
def update_selected_atoms(ids):
    if ids is None or len(ids) == 0:
        return "No atom has been selected. Select atoms by clicking on them."
    return "Selected atom IDs: {}.".format(', '.join([str(i) for i in ids]))


if __name__ == '__main__':
    app.run_server(debug=True)
