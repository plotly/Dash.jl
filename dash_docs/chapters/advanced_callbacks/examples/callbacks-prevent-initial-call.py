import dash
from dash.dependencies import Input, Output
import dash_html_components as html
from datetime import datetime
import time

app = dash.Dash()

app.layout = html.Div(
    [
        html.Button("execute callbacks", id="button_2"),
        html.Div(children="callback not executed", id="first_output_2"),
        html.Div(children="callback not executed", id="second_output_2"),
        html.Div(children="callback not executed", id="third_output_2"),
        html.Div(children="callback not executed", id="fourth_output_2"),
    ]
)


@app.callback(
    [Output("first_output_2", "children"), Output("second_output_2", "children")],
    [Input("button_2", "n_clicks")], prevent_initial_call=True)
def first_callback(n):
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    return ["in the first callback it is " + current_time, "in the first callback it is " + current_time]


@app.callback(
    Output("third_output_2", "children"), [Input("second_output_2", "children")], prevent_initial_call=True)
def second_callback(n):
    time.sleep(2)
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    return "in the second callback it is " + current_time


@app.callback(
    Output("fourth_output_2", "children"),
    [Input("first_output_2", "children"), Input("third_output_2", "children")], prevent_initial_call=True)
def third_output(n, m):
    time.sleep(2)
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    return "in the third callback it is " + current_time


if __name__ == '__main__':
    app.run_server(debug=True)
