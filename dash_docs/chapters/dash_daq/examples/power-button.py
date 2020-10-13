import dash
import dash_daq as daq
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.PowerButton(
        id='my-power-button',
        on=False
    ),
    html.Div(id='power-button-output')
])


@app.callback(
    dash.dependencies.Output('power-button-output', 'children'),
    [dash.dependencies.Input('my-power-button', 'on')])
def update_output(on):
    return 'The button is {}.'.format(on)


if __name__ == '__main__':
    app.run_server(debug=True)
