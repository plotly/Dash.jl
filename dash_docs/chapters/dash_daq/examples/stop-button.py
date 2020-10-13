import dash
import dash_daq as daq
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.StopButton(
        id='my-stop-button',
        label='Default',
        n_clicks=0
    ),
    html.Div(id='stop-button-output')
])


@app.callback(
    dash.dependencies.Output('stop-button-output', 'children'),
    [dash.dependencies.Input('my-stop-button', 'n_clicks')])
def update_output(n_clicks):
    return 'The stop button has been clicked {} times.'.format(n_clicks)


if __name__ == '__main__':
    app.run_server(debug=True)
