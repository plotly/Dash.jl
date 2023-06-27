using Dash

app = dash()

app.layout = html_div() do
    dcc_input(id="first", value = 1),
    dcc_input(id="second", value = 1),
    dcc_input(id="third", value = 1)
end

callback!(
    ClientsideFunction("clientside", "add1_no_update_at_11"),
    app, [Output("second","value"), Output("third","value")], Input("first","value"),
    [State("second","value"), State("third","value")]
    )


run_server(app)
