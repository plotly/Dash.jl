app = '''
using Dash
using DashHtmlComponents

app = dash("Test app")

app.layout = html_div() do
 html_div("Hello Dash.jl testing", id="container")
end

run_server(app)
'''

def test_jstr001_jl_with_string(dashjl):
    dashjl.start_server(app)
    dashjl.wait_for_text_to_equal(
        "#container", "Hello Dash.jl testing", timeout=10
    )
