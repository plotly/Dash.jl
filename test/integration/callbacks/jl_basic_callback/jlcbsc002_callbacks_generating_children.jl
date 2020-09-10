using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id="input", value = "initial value"),
    html_div(id="output")
end
callback!(app, Output("output","children"), Input("input","value")) do input
    return html_div() do
        dcc_input(id = "sub-input-1", value = "sub input initial value"),
        html_div(id = "sub-output-1")
    end
end

callback!(app, Output("sub-output-1","children"), Input("sub-input-1","value")) do value
    return value
end

run_server(app)
