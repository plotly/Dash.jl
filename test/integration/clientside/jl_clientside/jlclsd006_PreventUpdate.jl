using Dash

app = dash()

app.layout = html_div() do
    dcc_input(id="first", value = 1),
    dcc_input(id="second", value = 1),
    dcc_input(id="third", value = 1)
end

callback!(
    ClientsideFunction("clientside", "add1_prevent_at_11"),
    app, Output("second","value"), Input("first","value"), State("third","value")
    )

callback!(
    ClientsideFunction("clientside", "add1_prevent_at_11"),
    app, Output("third","value"), Input("second","value"), State("third","value")
    )


run_server(app)
