using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    html_label("x"),
    dcc_input(id="x", value = 3),
    html_label("y"),
    dcc_input(id="y", value = 6),
    html_label("x + y (clientside)"),
    dcc_input(id="x-plus-y"),
    html_label("x+y / 2 (serverside)"),
    dcc_input(id="x-plus-y-div-2"),
    html_div() do
        html_label("Display x, y, x+y/2 (serverside)"),
        dcc_textarea(id = "display-all-of-the-values")
    end,
    html_label("Mean(x, y, x+y, x+y/2) (clientside)"),
    dcc_input(id="mean-of-all-values")
end

callback!( 
    ClientsideFunction("clientside", "add"),
    app, callid"""
            x.value,
            y.value,
            => x-plus-y.value
            """) 
callback!(app, callid"x-plus-y.value => x-plus-y-div-2.value") do value
    return Float64(value) / 2.
end

callback!(app, callid"""
            x.value,
            y.value,
            x-plus-y.value,
            x-plus-y-div-2.value
            => display-all-of-the-values.value
            """
            ) do args...
    return join(string.(args), "\n")
end

callback!( 
    ClientsideFunction("clientside", "mean"),
    app, callid"""
            x.value,
            y.value,
            x-plus-y.value,
            x-plus-y-div-2.value
            => mean-of-all-values.value
            """) 

run_server(app)
