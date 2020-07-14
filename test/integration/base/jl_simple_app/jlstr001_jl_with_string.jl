using Dash
using DashHtmlComponents

app = dash()

app.layout = html_div() do
    html_div("Hello Dash.jl testing", id="container")
end

run_server(app)