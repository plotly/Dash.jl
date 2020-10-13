import dash
import dash_daq as daq
import dash_core_components as dcc
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.LEDDisplay(
        id='my-LED-display',
        label="Default",
        value=6
    ),
    dcc.Slider(
        id='my-LED-display-slider',
        min=0,
        max=10,
        step=1,
        value=5
    ),
])


@app.callback(
    dash.dependencies.Output('my-LED-display', 'value'),
    [dash.dependencies.Input('my-LED-display-slider', 'value')]
)
def update_output(value):
    return str(value)

if __name__ == '__main__':
    app.run_server(debug=True)
