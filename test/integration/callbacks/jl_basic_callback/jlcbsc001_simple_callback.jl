using Dash

app = dash()

app.layout = html_div() do
    dcc_input(id="input", value = "initial value"),
    html_div() do
        html_div(
            [
                1.5,
                nothing,
                "string",
                html_div(id="output")
            ]
        )
    end
end
call_count = 0
callback!(app,
    Output("output","children"),
    Input("input","value")
    ) do value
    return value
end

run_server(app)
