using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    html_div("hello", id="input"),
    html_div(id="side-effect"),
    html_div("output", id="output")
end

callback!( 
    ClientsideFunction("clientside", "side_effect_and_return_a_promise"),
    app, Output("output","children"), Input("input","children")
    )


run_server(app)