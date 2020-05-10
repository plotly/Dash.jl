app = '''
using Dash
using DashHtmlComponents

println("00000")
app = dash("Test app")

app.layout = html_div() do
 html_div("Hello Dash.jl testing", id="container")
end

println("111")
run_server(app, "127.0.0.1", 8050)
'''

def test_jstr001_jl_with_string(dashjl, start_timeout=20):
    dashjl.start_server(app)
    dashjl.wait_for_text_to_equal(
        "#container", "Hello Dash.jl testing", timeout=10
    )
