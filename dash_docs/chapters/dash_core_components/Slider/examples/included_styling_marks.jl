using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div() do
    dcc_slider(
        min=0,
        max=100,
        step=nothing,
        value=1,
        marks=Dict("0" => Dict("label" => "0°C", "style" => ("color", "#77b0b1")))
    )
end


run_server(app, "0.0.0.0", debug=true)
