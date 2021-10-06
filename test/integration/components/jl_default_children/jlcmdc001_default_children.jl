using Dash

app = dash()
app.layout = html_div(id="outer-div") do
    html_div("A div", id="first-inner-div"),
    html_br(),
    html_div("Another div", id="second-inner-div")
end

run_server(app)
