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
    'mol3d/model_data.js'
).read()
styles_data = urlreq.urlopen(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'mol3d/styles_data.js'
).read()

if PY3:
    model_data = model_data.decode('utf-8')
    styles_data = styles_data.decode('utf-8')

model_data = json.loads(model_data)
styles_data = json.loads(styles_data)

app.layout = html.Div([
    dashbio.Molecule3dViewer(
        id='my-dashbio-molecule3d',
        styles=styles_data,
        modelData=model_data
    ),
    "Selection data",
    html.Hr(),
    html.Div(id='molecule3d-output')
])


@app.callback(
    dash.dependencies.Output('molecule3d-output', 'children'),
    [dash.dependencies.Input('my-dashbio-molecule3d', 'selectedAtomIds')]
)
def show_selected_atoms(atom_ids):
    if atom_ids is None or len(atom_ids) == 0:
        return 'No atom has been selected. Click somewhere on the molecular \
        structure to select an atom.'
    return [html.Div([
        html.Div('Element: {}'.format(model_data['atoms'][atm]['element'])),
        html.Div('Chain: {}'.format(model_data['atoms'][atm]['chain'])),
        html.Div('Residue name: {}'.format(model_data['atoms'][atm]['residue_name'])),
        html.Br()
    ]) for atm in atom_ids]


if __name__ == '__main__':
    app.run_server(debug=True)
