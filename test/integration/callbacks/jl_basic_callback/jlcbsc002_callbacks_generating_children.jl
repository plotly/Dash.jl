using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id="input", value = "initial value"),
    html_div(id="output")
end
callback!(app, callid"input.value => output.children") do input
    return html_div() do
        dcc_input(id = "sub-input-1", value = "sub input initial value"),
        html_div(id = "sub-output-1")
    end
end

callback!(app, callid"sub-input-1.value => sub-output-1.children") do value
    return value
end

run_server(app)