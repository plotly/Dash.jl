using Dash
using DashHtmlComponents

app = dash(;update_title = "... computing !")
app.layout = html_div(children = "Hello world!", id = "hello-div")
run_server(app)
