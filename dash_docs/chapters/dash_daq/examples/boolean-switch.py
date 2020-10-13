import dash
import dash_daq as daq
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.BooleanSwitch(
        id='my-boolean-switch',
        on=False
    ),
    html.Div(id='boolean-switch-output')
])


@app.callback(
    dash.dependencies.Output('boolean-switch-output', 'children'),
    [dash.dependencies.Input('my-boolean-switch', 'on')])
def update_output(on):
    return 'The switch is {}.'.format(on)


if __name__ == '__main__':
    app.run_server(debug=True)
