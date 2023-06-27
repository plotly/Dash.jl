using Dash

app = dash(meta_tags = [Dict(["charset"=>"ISO-8859-1", "keywords"=>"dash,pleasant,productive", "http-equiv"=>"content-type", "content"=>"text/html"])])

app.layout = html_div(children = "Hello world!", id = "hello-div")

run_server(app)
