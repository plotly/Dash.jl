
using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_dropdown(id = "input",
        options = [
            (label="regular", value="regular"),
            (label="prevent", value="prevent"),
            (label="no_update1", value="no_update1"),
            (label="no_update2", value="no_update2"),
        ] 
    ),
    html_div(id="output1"),
    html_div(id="output2"),
    html_div(id="regular_output")
end
callback!(app, Output("regular_output","children"), Input("input","value")) do input
    return input
end

callback!(app, Output("output1","children"), Output("output2","children"), Input("input","value")) do input
    input == "prevent" && throw(PreventUpdate())
    if input == "no_update1"
        return (no_update(), input)
    end
    if input == "no_update2"
        return (input, no_update())
    end
    return (input, input)
end


run_server(app)
