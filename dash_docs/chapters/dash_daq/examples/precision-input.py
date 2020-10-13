import dash
import dash_daq as daq
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.PrecisionInput(
        id='my-precision',
        label='Default',
        precision=4,
        value=1234
    ),
    html.Div(id='precision-output')
])


@app.callback(
    dash.dependencies.Output('precision-output', 'children'),
    [dash.dependencies.Input('my-precision', 'value')])
def update_output(value):
    return 'The current value is {}.'.format(value)


if __name__ == '__main__':
    app.run_server(debug=True)
