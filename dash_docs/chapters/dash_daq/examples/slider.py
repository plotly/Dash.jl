import dash
import dash_daq as daq
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.Slider(
        id='my-daq-slider-ex',
        value=17
    ),
    html.Div(id='slider-output')
])


@app.callback(
    dash.dependencies.Output('slider-output', 'children'),
    [dash.dependencies.Input('my-daq-slider-ex', 'value')])
def update_output(value):
    return 'The slider is currently at {}.'.format(value)


if __name__ == '__main__':
    app.run_server(debug=True)
