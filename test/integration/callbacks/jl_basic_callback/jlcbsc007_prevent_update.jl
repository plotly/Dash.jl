using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_dropdown(id = "input",
        options = [
            (label="regular", value="regular"),
            (label="prevent", value="prevent"),
            (label="no_update", value="no_update"),
        ] 
    ),
    html_div(id="output"),
    html_div(id="regular_output")
end
callback!(app, callid"input.value => regular_output.children") do input
    return input
end
callback!(app, callid"input.value => output.children") do input
    input == "prevent" && throw(PreventUpdate())
    input == "no_update" && return no_update()
    return input
end


run_server(app)
