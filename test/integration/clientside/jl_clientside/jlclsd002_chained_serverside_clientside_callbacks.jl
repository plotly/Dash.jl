using Dash

app = dash()

app.layout = html_div() do
    html_label("x"),
    dcc_input(id="x", value = 3),
    html_label("y"),
    dcc_input(id="y", value = 6),
    html_label("x + y (clientside)"),
    dcc_input(id="x-plus-y"),
    html_label("x+y / 2 (serverside)"),
    dcc_input(id="x-plus-y-div-2"),
    html_div() do
        html_label("Display x, y, x+y/2 (serverside)"),
        dcc_textarea(id = "display-all-of-the-values")
    end,
    html_label("Mean(x, y, x+y, x+y/2) (clientside)"),
    dcc_input(id="mean-of-all-values")
end

callback!(
    ClientsideFunction("clientside", "add"),
    app,
    Output("x-plus-y", "value"),
    [Input("x","value"), Input("y","value")]
    )

callback!(app, Output("x-plus-y-div-2", "value"), Input("x-plus-y", "value")) do value
    return Float64(value) / 2.
end

callback!(app,
        Output("display-all-of-the-values", "value"),
        [Input("x","value"), Input("y","value"), Input("x-plus-y","value"), Input("x-plus-y-div-2","value")]
        ) do args...
    return join(string.(args), "\n")
end

callback!(
    ClientsideFunction("clientside", "mean"),
    app,
    Output("mean-of-all-values","value"),
    [Input("x","value"), Input("y","value"), Input("x-plus-y","value"), Input("x-plus-y-div-2","value")]
)

run_server(app)
