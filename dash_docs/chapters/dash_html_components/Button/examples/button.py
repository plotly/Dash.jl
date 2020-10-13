import dash
import dash_html_components as html
import dash_core_components as dcc

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
app.layout = html.Div([
    html.Div(dcc.Input(id='submit-input-box', type='text')),
    html.Button('Submit', id='submit-button-example'),
    html.Div(id='submit-output-button',
             children='Enter a value and press submit')
])


@app.callback(
    dash.dependencies.Output('submit-output-button', 'children'),
    [dash.dependencies.Input('submit-button-example', 'n_clicks')],
    [dash.dependencies.State('submit-input-box', 'value')])
def update_output(n_clicks, value):
    return 'The input value was "{}" and the button has been clicked {} times'.format(
        value,
        n_clicks
    )


if __name__ == '__main__':
    app.run_server(debug=True)
