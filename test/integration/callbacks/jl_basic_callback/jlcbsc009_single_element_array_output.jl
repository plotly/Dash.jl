
using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id="input", value = "initial value"),
    html_div(id = "output")
end
callback!(app, 
    [Output("output","children")],
    Input("input","value")
    ) do value
    return (value,)
end

run_server(app)
