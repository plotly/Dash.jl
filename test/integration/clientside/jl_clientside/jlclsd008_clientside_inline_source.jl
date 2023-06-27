using Dash

app = dash()

app.layout = html_div() do
    dcc_input(id="input"),
    html_div(id="output-clientside"),
    html_div(id="output-serverside")
end

callback!(app, Output("output-serverside","children"), Input("input","value")) do value
    return "Server says \"$(value)\""
end

callback!(
    """
    function (value) {
        return 'Client says "' + value + '"';
    }
    """,
    app, Output("output-clientside","children"), Input("input","value") )

run_server(app)
