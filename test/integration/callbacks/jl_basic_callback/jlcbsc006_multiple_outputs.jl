using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id="input", value = "initial value"),
    html_div(id="output1"),
    html_div(id="output2")
end
callback!(app, callid"input.value => output1.children, output2.children") do input
    return ("$input first", "$input second")
end


run_server(app)
