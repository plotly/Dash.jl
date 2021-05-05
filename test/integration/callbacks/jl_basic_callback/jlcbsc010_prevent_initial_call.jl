using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id="input", value = "initial value"),
    dcc_input(id="input2", value = "prevented"),
    html_div("initial",id="output")
end
callback!(app,
    Output("input2","value"),
    Input("input","value"),
    prevent_initial_call = true
    ) do value
    return value
end
callback!(app,
    Output("output","children"),
    Input("input2","value")
    ) do value
    return value
end

run_server(app)
