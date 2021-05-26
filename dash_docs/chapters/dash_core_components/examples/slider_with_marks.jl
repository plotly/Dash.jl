using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div() do
    dcc_slider(
        min=1,
        max=10,
        step=nothing,
        value=1,
        marks=Dict([i => ("Label $(i)") for i = 1:10]),
    )
end

run_server(app, "0.0.0.0", debug=true)
