import dash
from dash.exceptions import PreventUpdate
import dash_html_components as html
import dash_core_components as dcc

external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]

options = [
    {"label": "New York City", "value": "NYC"},
    {"label": "Montreal", "value": "MTL"},
    {"label": "San Francisco", "value": "SF"},
]

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
app.layout = html.Div(
    [
        html.Label(["Single dynamic Dropdown", dcc.Dropdown(id="my-dynamic-dropdown")]),
        html.Label(
            [
                "Multi dynamic Dropdown",
                dcc.Dropdown(id="my-multi-dynamic-dropdown", multi=True),
            ]
        ),
    ]
)


@app.callback(
    dash.dependencies.Output("my-dynamic-dropdown", "options"),
    [dash.dependencies.Input("my-dynamic-dropdown", "search_value")],
)
def update_options(search_value):
    if not search_value:
        raise PreventUpdate
    return [o for o in options if search_value in o["label"]]


@app.callback(
    dash.dependencies.Output("my-multi-dynamic-dropdown", "options"),
    [dash.dependencies.Input("my-multi-dynamic-dropdown", "search_value")],
    [dash.dependencies.State("my-multi-dynamic-dropdown", "value")],
)
def update_multi_options(search_value, value):
    if not search_value:
        raise PreventUpdate
    # Make sure that the set values are in the option list, else they will disappear
    # from the shown select list, but still part of the `value`.
    return [
        o for o in options if search_value in o["label"] or o["value"] in (value or [])
    ]


if __name__ == "__main__":
    app.run_server(debug=True)
