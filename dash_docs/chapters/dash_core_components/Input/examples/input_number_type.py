import dash_core_components as dcc
import dash_html_components as html
import dash
from dash.dependencies import Input, Output

app = dash.Dash(__name__)
app.layout = html.Div(
    [
        dcc.Input(id="dfalse", type="number", placeholder="Debounce False"),
        dcc.Input(
            id="dtrue", type="number",
            debounce=True, placeholder="Debounce True",
        ),
        dcc.Input(
            id="input_range", type="number", placeholder="input with range",
            min=10, max=100, step=3,
        ),
        html.Hr(),
        html.Div(id="number-out"),
    ]
)


@app.callback(
    Output("number-out", "children"),
    [Input("dfalse", "value"), Input("dtrue", "value"), Input("input_range", "value")],
)
def number_render(fval, tval, rangeval):
    return "dfalse: {}, dtrue: {}, range: {}".format(fval, tval, rangeval)


if __name__ == "__main__":
    app.run_server(debug=True)
