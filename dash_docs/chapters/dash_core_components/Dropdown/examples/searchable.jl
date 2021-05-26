using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div(style = Dict("height" => "150px")) do
    dcc_dropdown(
        options = [
            (label = "New York City", value = "NYC"),
            (label = "Montreal", value = "MTL"),
            (label = "San Francisco", value = "SF")
        ],
        value = "MTL",
        searchable=false
    )
end

run_server(app, "0.0.0.0", debug=true)
