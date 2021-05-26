using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div() do
    dcc_input(id = "input-10", type = "text", value = "Montreal"),
    dcc_input(id = "input-20", type = "text", value = "Canada"),
    html_div(id = "output-keywords1")
end

callback!(
    app,
    Output("output-keywords1", "children"),
    Input("input-10", "value"),
    Input("input-20", "value"),
) do input_1, input_2
    return "Input 1 is \"$input_1\" and Input 2 is \"$input_2\""
end

run_server(app, "0.0.0.0", debug=true)
