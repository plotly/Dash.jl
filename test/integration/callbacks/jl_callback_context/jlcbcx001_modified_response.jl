using HTTP
using Dash

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

    cookie_str = HTTP.Cookies.stringify(cookie)
    println(cookie_str)
    http_response = callback_context().response
    push!(http_response.headers, "Set-Cookie"=>cookie_str)
    return value * " - output"
end

run_server(app)
