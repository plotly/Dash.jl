using CSV, DataFrames, JSON3
using Dash, DashHtmlComponents, DashCoreComponents

df5 = DataFrame(
    x = [1, 2, 1, 2],
    y = [1, 2, 3, 4],
    customdata = [1, 2, 3, 4],
    fruit = ["apple", "apple", "orange", "orange"],
)

app = dash()

app.layout = html_div() do
    dcc_graph(id = "basic-interactions", figure = (
        data = [
            (
                x = [1,2,3,4],
                y = [4,1,3,5],
                text = ["a", "b", "c", "d"],
                customdata = ["c.a", "c.b", "c.c", "c.d"],
                name = "Trace 1",
                mode = "markers",
                marker = (size = 12,)
            ),
            (
                x = [1,2,3,4],
                y = [9,4,1,4],
                text = ["w", "x", "y", "z"],
                customdata = ["c.w", "c.x", "c.y", "c.z"],
                name = "Trace 2",
                mode = "markers",
                marker = (size = 12,)
            )
        ],
        layout = (clickmode = "event+select",)
    )),
    html_div(
        children = [
            html_div(
                children = [
                    dcc_markdown("
                    **Hover Data**

                    Mouse over values in the graph.
                    "),
                    html_pre(id = "hover-data"),
                ],
            ),
            html_div(
                children = [
                    dcc_markdown("
                    **Click Data**

                    Click on points in the graph.
                    "),
                    html_pre(id = "click-data"),
                ],
            ),
            html_div(
                children = [
                    dcc_markdown("
                    **Selection Data**

                    Choose the lasso or rectangle tool in the graph's menu
                    bar and then select points in the graph.

                    Note that if `layout.clickmode = 'event+select'`, selection data also
                    accumulates (or un-accumulates) selected data if you hold down the shift
                    button while clicking.
                    "),
                    html_pre(id = "selected-data"),
                ],
            ),
            html_div(
                children = [
                    dcc_markdown("
                    **Zoom and Relayout Data**

                    Click and drag on the graph to zoom or click on the zoom
                    buttons in the graph's menu bar.
                    Clicking on legend items will also fire
                    this event.
                    "),
                    html_pre(id = "relayout-data"),
                ],
            ),
        ],
    )

end

callback!(
    app,
    Output("hover-data", "children"),
    Input("basic-interactions", "hoverData"),
) do hover_data

    return JSON3.write(hover_data)
end

callback!(
    app,
    Output("click-data", "children"),
    Input("basic-interactions", "clickData"),
) do click_data

    return JSON3.write(click_data)
end

callback!(
    app,
    Output("selected-data", "children"),
    Input("basic-interactions", "selectedData"),
) do selected_data

    return string(selected_data)
end

callback!(
    app,
    Output("relayout-data", "children"),
    Input("basic-interactions", "relayoutData"),
) do relayout_data

    return string(relayout_data)
end

run_server(app, "0.0.0.0", debug=true)
