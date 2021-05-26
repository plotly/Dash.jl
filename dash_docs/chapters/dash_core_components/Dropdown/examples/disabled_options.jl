using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div(style = Dict("height" => "150px")) do
    dcc_dropdown(
        options = [
            (label = "New York City", value = "NYC", disabled=true),
            (label = "Montreal", value = "MTL"),
            (label = "San Francisco", value = "SF", disabled=true)
        ]
    )
end

run_server(app, "0.0.0.0", debug=true)
