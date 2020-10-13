import dash
import dash_daq as daq
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    daq.Joystick(
        id='my-joystick',
        label="Default",
        angle=0
    ),
    html.Div(id='joystick-output')
])


@app.callback(
    dash.dependencies.Output('joystick-output', 'children'),
    [dash.dependencies.Input('my-joystick', 'angle'),
     dash.dependencies.Input('my-joystick', 'force')])
def update_output(angle, force):
    return ['Angle is {}'.format(angle),
            html.Br(),
            'Force is {}'.format(force)]


if __name__ == '__main__':
    app.run_server(debug=True)
