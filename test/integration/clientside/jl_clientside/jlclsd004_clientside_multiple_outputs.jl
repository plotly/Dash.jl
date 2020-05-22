using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id="input", value = 1),
    dcc_input(id="output-1"),
    dcc_input(id="output-2"),
    dcc_input(id="output-3"),
    dcc_input(id="output-4")
end

callback!( 
    ClientsideFunction("clientside", "add_to_four_outputs"),
    app, callid"input.value=>output-1.value, output-2.value, output-3.value, output-4.value"
    )


run_server(app)