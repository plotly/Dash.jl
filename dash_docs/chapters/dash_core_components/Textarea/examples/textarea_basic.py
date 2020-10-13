import dash
from dash.dependencies import Input, Output
import dash_html_components as html
import dash_core_components as dcc

app = dash.Dash(__name__)

app.layout = html.Div([
    dcc.Textarea(
        id='textarea-example',
        value='Textarea content initialized\nwith multiple lines of text',
        style={'width': '100%', 'height': 300},
    ),
    html.Div(id='textarea-example-output', style={'whiteSpace': 'pre-line'})
])

@app.callback(
    Output('textarea-example-output', 'children'),
    [Input('textarea-example', 'value')]
)
def update_output(value):
    return 'You have entered: \n{}'.format(value)

if __name__ == '__main__':
    app.run_server(debug=True)
