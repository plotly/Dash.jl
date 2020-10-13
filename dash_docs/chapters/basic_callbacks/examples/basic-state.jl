using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div() do
    dcc_input(id = "input-1-state", type = "text", value = "Montreal"),
    dcc_input(id = "input-2-state", type = "text", value = "Canada"),
    html_button(id = "submit-button-state", children = "submit", n_clicks = 0),
    html_div(id = "output-state")
end

callback!(
    app,
    Output("output-state", "children"),
    Input("submit-button-state", "n_clicks"),
    State("input-1-state", "value"),
    State("input-2-state", "value"),
) do clicks, input_1, input_2
    return "The Button has been pressed \"$clicks\" times, Input 1 is \"$input_1\" and Input 2 is \"$input_2\""
end

run_server(app, "0.0.0.0", debug=true)
