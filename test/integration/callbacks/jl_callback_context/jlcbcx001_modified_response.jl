using HTTP
using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()
app.layout = html_div() do
    dcc_input(id = "input", value = "ab"),
    html_div(id = "output")
end

callback!(app, 
    Output("output", "children"),
    Input("input", "value")
) do value
    cookie = HTTP.Cookie("dash_cookie", value * " - cookie")

    println(String(cookie, false))
    http_response = callback_context().response
    push!(http_response.headers, "Set-Cookie"=>String(cookie, false))
    return value * " - output"
end

run_server(app)