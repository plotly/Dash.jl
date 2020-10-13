import dash
import dash_bio as dashbio
import dash_html_components as html
import dash_core_components as dcc

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    'Select which chromosomes to display on the ideogram below:',
    dcc.Dropdown(
        id='displayed-chromosomes',
        options=[{'label': str(i), 'value': str(i)} for i in range(1, 23)],
        multi=True,
        value=[str(i) for i in range(1, 23)]
    ),
    dashbio.Ideogram(
        id='my-dashbio-ideogram'
    ),
    html.Div(id='ideogram-rotated')
])


@app.callback(
    dash.dependencies.Output('my-dashbio-ideogram', 'chromosomes'),
    [dash.dependencies.Input('displayed-chromosomes', 'value')]
)
def update_ideogram(value):
    return value


@app.callback(
    dash.dependencies.Output('ideogram-rotated', 'children'),
    [dash.dependencies.Input('my-dashbio-ideogram', 'rotated')]
)
def update_ideogram_rotated(rot):
    return 'You have {} selected a chromosome.'.format(
        '' if rot else 'not')


if __name__ == '__main__':
    app.run_server(debug=True)
