using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div() do
    dcc_slider(
        id="my-slider-1",
        min=1,
        max=10,
        step=1,
        value=1,
    ),
    html_div(id="slider-output-container")
end

callback!(
    app,
    Output("slider-output-container", "children"),
    Input("my-slider-1", "value"),
) do value
    return "You have selected \"$value\""
end

run_server(app, "0.0.0.0", debug=true)
