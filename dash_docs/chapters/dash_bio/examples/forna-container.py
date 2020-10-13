import dash
import dash_bio as dashbio
import dash_core_components as dcc
import dash_html_components as html
from dash.exceptions import PreventUpdate

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

sequences = {
    'PDB_01019': {
        'sequence': 'AUGGGCCCGGGCCCAAUGGGCCCGGGCCCA',
        'structure': '.((((((())))))).((((((()))))))'
    },
    'PDB_00598': {
        'sequence': 'GGAGAUGACgucATCTcc',
        'structure': '((((((((()))))))))'
    }
}

app.layout = html.Div([
    dashbio.FornaContainer(
        id='forna'
    ),
    html.Hr(),
    html.P('Select the sequences to display below.'),
    dcc.Dropdown(
        id='forna-sequence-display',
        options=[
            {'label': name, 'value': name} for name in sequences.keys()
        ],
        multi=True,
        value=['PDB_01019']
    )
])


@app.callback(
    dash.dependencies.Output('forna', 'sequences'),
    [dash.dependencies.Input('forna-sequence-display', 'value')]
)
def show_selected_sequences(value):
    if value is None:
        raise PreventUpdate
    return [
        sequences[selected_sequence]
        for selected_sequence in value
    ]


if __name__ == '__main__':
    app.run_server(debug=True)
