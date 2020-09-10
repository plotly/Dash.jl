using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id="input", value = "initial value"),
    html_div(id="output1"),
    html_div(id="output2")
end
callback!(app, Output("output1","children"), Output("output2","children"), Input("input","value")) do input
    return ("$input first", "$input second")
end


run_server(app)
