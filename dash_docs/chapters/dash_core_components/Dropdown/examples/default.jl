using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div(style = Dict("height" => "150px")) do
    dcc_dropdown(
        id="demo-dropdown",
        options = [
            (label = "New York City", value = "NYC"),
            (label = "Montreal", value = "MTL"),
            (label = "San Francisco", value = "SF")
        ],
        value = "MTL",
    ),
    html_div(id="dd-output-container")

end

callback!(
    app,
    Output("dd-output-container", "children"),
    Input("demo-dropdown", "value"),
) do input_1
    return "You have selected \"$input_1\""
end

run_server(app, "0.0.0.0", debug=true)
