import dash
import dash_daq as daq
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.Indicator(
        id='my-indicator',
        label="Default",
    ),
    html.Button(
        'On/Off',
        id='my-indicator-button',
        n_clicks=0
    ),
])


@app.callback(
    dash.dependencies.Output('my-indicator', 'value'),
    [dash.dependencies.Input('my-indicator-button', 'n_clicks')]
)
def update_output(value):
    if value % 2 == 0:
        value = True
    else:
        value = False
    return value


if __name__ == '__main__':
    app.run_server(debug=True)
