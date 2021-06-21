using Dash

app = dash()

app.layout = html_div() do
    dcc_dropdown(id = "input",
        options = [
            (label="regular", value="regular"),
            (label="prevent", value="prevent"),
            (label="no_update", value="no_update"),
        ]
    ),
    html_div(id="output"),
    html_div(id="regular_output")
end
callback!(app, Output("regular_output","children"), Input("input","value")) do input
    return input
end

callback!(app, Output("output","children"), Input("input","value")) do input
    input == "prevent" && throw(PreventUpdate())
    input == "no_update" && return no_update()
    return input
end


run_server(app)
