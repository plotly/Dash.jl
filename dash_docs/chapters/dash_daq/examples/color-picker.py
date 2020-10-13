import dash
import dash_daq as daq
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.ColorPicker(
        id='my-color-picker',
        label='Color Picker',
        value=dict(hex='#119DFF')
    ),
    html.Div(id='color-picker-output')
])


@app.callback(
    dash.dependencies.Output('color-picker-output', 'children'),
    [dash.dependencies.Input('my-color-picker', 'value')])
def update_output(value):
    return 'The selected color is {}.'.format(value)


if __name__ == '__main__':
    app.run_server(debug=True)
