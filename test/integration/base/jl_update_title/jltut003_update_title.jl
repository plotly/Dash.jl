using Dash
using DashHtmlComponents

app = dash(;update_title = "")
app.layout = html_div(children = "Hello world!", id = "hello-div")
run_server(app)
