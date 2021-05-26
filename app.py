import dash
import dash_html_components as html
import dash_core_components as dcc
from dash.dependencies import Input, Output

app = dash.Dash(__name__)

app.layout = html.Div(
    [
        dcc.Checklist(
            id="checklist",
            options=[
                {"label": "New York City", "value": "NYC"},
                {"label": "Montréal", "value": "MTL"},
                {"label": "San Francisco", "value": "SF"},
            ],
            labelStyle={'display': 'block'}
        ),
        html.Button("load", id="load-button"),
    ]
)


@app.callback(Output("checklist", "value"), Input("load-button", "n_clicks"))
def change_values(n_clicks):
    # callbacks execute once when the app loads, so this is the first state of the Checkbox the user sees
    if n_clicks is None:
        return ["NYC", "MTL"]

    # button clicked once
    if n_clicks == 1:
        return ["SF"]

    # button clicked twice
    if n_clicks == 2:
        return ["SF", "MTL"]

    # n_clicks is not None, or 1, or 2 (3 or greater)
    return ["NYC", "MTL", "SF"]

if __name__ == "__main__":
    app.run_server(debug=False)
