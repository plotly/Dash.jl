import dash
import dash_daq as daq
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.Knob(
        id='my-knob',
    ),
    html.Div(id='knob-output')
])


@app.callback(
    dash.dependencies.Output('knob-output', 'children'),
    [dash.dependencies.Input('my-knob', 'value')])
def update_output(value):
    return 'The knob value is {}.'.format(value)


if __name__ == '__main__':
    app.run_server(debug=True)
