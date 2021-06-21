using Dash

outputs = [
    [nothing, ""],
    ["a string", "a string"],
    [123, "123"],
    [123.45, "123.45"],
    [[6, 7, 8], "678"],
    [["a", "list", "of", "strings"], "alistofstrings"],
    [["strings", 2, "numbers"], "strings2numbers"],
    [["a string", html_div("and a div")], "a string\nand a div"],
]
app = dash()

app.layout = html_div() do
    html_button(id="btn", children = "Update Input"),
    html_div(id = "out", children = "init")
end

callback!(app, Output("out","children"), Input("btn","n_clicks")) do n_clicks
    (isnothing(n_clicks) || n_clicks > length(outputs)) && throw(PreventUpdate())
    return outputs[n_clicks][1]
end

run_server(app)
