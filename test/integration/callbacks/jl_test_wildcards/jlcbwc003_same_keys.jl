using Dash

app = dash(suppress_callback_exceptions = true)

app.layout = html_div() do
    html_button("Add Filter", id="add-filter", n_clicks=0),
    html_div([], id="container")
end

callback!(app,
        Output("container", "children"),
        Input("add-filter", "n_clicks"),
        State("container", "children")
    ) do n_clicks, children
    new_element = html_div() do
        dcc_dropdown(
            id = (type = "dropdown", index = n_clicks),
            options = [(label = i, value = i) for i in ["NYC", "MTL", "LA", "TOKYO"]]
        ),
        html_div(
            id = (type = "output", index = n_clicks)
        )
    end
    return vcat(children, new_element)
end


callback!(app,
    Output((type = "output", index = MATCH), "children"),
    Input((type = "dropdown", index = MATCH), "value"),
    State((type = "dropdown", index = MATCH), "id"),
) do value, id
    return html_div("Dropdown $(id.index) = $(value)")
end

run_server(app)
