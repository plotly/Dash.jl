using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

dropdown_options = [
    Dict("label" => "New York City", "value" => "NYC"),
    Dict("label" => "Montreal", "value" => "MTL"),
    Dict("label" => "San Francisco", "value" => "SF"),
]
app.layout = html_div(style = Dict("columnCount" => 2)) do
    html_label("Dropdown"),
    dcc_dropdown(options = dropdown_options, value = "MTL"),
    html_label("Multi-Select Dropdown"),
    dcc_dropdown(
        options = dropdown_options,
        value = ["MTL", "SF"],
        multi = true,
    ),
    html_label("Radio Items"),
    dcc_radioitems(options = dropdown_options, value = "MTL"),
    html_label("Checkboxes"),
    dcc_checklist(options = dropdown_options, value = ["MTL", "SF"]),
    html_label("Text Input"),
    dcc_input(value = "MTL", type = "text"),
    html_label("Slider"),
    dcc_slider(
        min = 0,
        max = 9,
        marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:6]),
        value = 5,
    )
end

run_server(app, "0.0.0.0", 8000, debug = true)
