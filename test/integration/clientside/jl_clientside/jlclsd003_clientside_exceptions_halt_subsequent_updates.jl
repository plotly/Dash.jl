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
    app, callid"first.value=>second.value"
    )

callback!( 
    ClientsideFunction("clientside", "add1_break_at_11"),
    app, callid"second.value=>third.value"
    )

run_server(app)