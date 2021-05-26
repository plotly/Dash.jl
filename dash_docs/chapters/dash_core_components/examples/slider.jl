using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div() do
    dcc_slider(
        min=-5,
        max=10,
        step=0.5,
        value=-3
    )
end

run_server(app, "0.0.0.0", debug=true)
