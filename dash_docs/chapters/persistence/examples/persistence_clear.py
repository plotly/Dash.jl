import dash
from dash.dependencies import Input, Output
import dash_core_components as dcc
import dash_html_components as html

INITIAL = '1+1=2'

app = dash.Dash(__name__)

app.layout = html.Div([
    "Remember this important info:",
    html.Br(),
    dcc.Input(id='important-info', value=INITIAL, persistence=True),
    html.Button("Forget it!", id='clear-info')
])


@app.callback(
    Output('important-info', 'value'),
    [Input('clear-info', 'n_clicks')]
)
def clear_persistence(n):
    return INITIAL if n else dash.no_update


if __name__ == '__main__':
    app.run_server(debug=True)
