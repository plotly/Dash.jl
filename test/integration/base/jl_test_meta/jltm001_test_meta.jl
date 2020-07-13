using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash(meta_tags = [Dict(["name"=>"description", "content" => "some content"])])

app.layout = html_div(children = "Hello world!", id = "hello-div")

run_server(app)