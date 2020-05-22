using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id="input"),
    html_div(id="output-clientside"),
    html_div(id="output-serverside")
end

callback!(app, callid"input.value=>output-serverside.children") do value
    return "Server says \"$(value)\""
end

callback!( 
    """
    function (value) {
        return 'Client says "' + value + '"';
    }
    """,
    app, callid"input.value=>output-clientside.children") 

run_server(app)