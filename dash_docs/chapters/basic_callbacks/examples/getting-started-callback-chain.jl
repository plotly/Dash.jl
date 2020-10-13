using CSV, DataFrames
using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

all_options = Dict(
    "America" => ["New York City", "San Francisco", "Cincinnati"],
    "Canada" => ["Montreal", "Toronto", "Ottawa"],
)

app.layout = html_div() do
    html_div(
        children = [
            dcc_radioitems(
                id = "countries-radio",
                options = [(label = i, value = i) for i in keys(all_options)],
                value = "America",
            ),
            html_hr(),
            dcc_radioitems(id = "cities-radio"),
            html_hr(),
            html_div(id = "display-selected-values"),
        ],
    )
end

callback!(
    app,
    Output("cities-radio", "options"),
    Input("countries-radio", "value"),
) do selected_country
    return [(label = i, value = i) for i in all_options[selected_country]]
end

callback!(
    app,
    Output("cities-radio", "value"),
    Input("cities-radio", "options"),
) do available_options
    return available_options[1][:value]
end

callback!(
    app,
    Output("display-selected-values", "children"),
    Input("countries-radio", "value"),
    Input("cities-radio", "value"),
) do selected_country, selected_city
    return "$(selected_city) is a city in $(selected_country) "
end

run_server(app, "0.0.0.0", debug=true)
