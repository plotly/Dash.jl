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
    app, 
    [Output("output-1","value"), Output("output-2","value"), Output("output-3","value"), Output("output-4","value")],
    Input("input","value")
    )


run_server(app)