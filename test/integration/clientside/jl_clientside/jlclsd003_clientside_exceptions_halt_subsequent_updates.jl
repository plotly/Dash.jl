using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id="first", value = 1),
    dcc_input(id="second"),
    dcc_input(id="third")
end

callback!( 
    ClientsideFunction("clientside", "add1_break_at_11"),
    app, Output("second", "value"), Input("first", "value")
    )

callback!( 
    ClientsideFunction("clientside", "add1_break_at_11"),
    app, Output("third", "value"), Input("second","value")
    )

run_server(app)