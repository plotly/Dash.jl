import dash
import dash_daq as daq
import dash_core_components as dcc
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.GraduatedBar(
        id='my-graduated-bar',
        label="Default",
        value=6
    ),
    dcc.Slider(
        id='my-graduated-bar-slider',
        min=0,
        max=10,
        step=1,
        value=5
    ),
])


@app.callback(
    dash.dependencies.Output('my-graduated-bar', 'value'),
    [dash.dependencies.Input('my-graduated-bar-slider', 'value')]
)
def update_output(value):
    return value


if __name__ == '__main__':
    app.run_server(debug=True)
