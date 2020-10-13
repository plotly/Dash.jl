import dash
import dash_daq as daq
import dash_core_components as dcc
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.Thermometer(
        id='my-thermometer',
        value=5,
        min=0,
        max=10,
        style={
            'margin-bottom': '5%'
        }
    ),
    dcc.Slider(
        id='thermometer-slider',
        value=5,
        min=0,
        max=10,

    ),
])


@app.callback(
    dash.dependencies.Output('my-thermometer', 'value'),
    [dash.dependencies.Input('thermometer-slider', 'value')])
def update_thermometer(value):
    return value


if __name__ == '__main__':
    app.run_server(debug=True)
