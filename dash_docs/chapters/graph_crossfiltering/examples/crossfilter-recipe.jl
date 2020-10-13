
using DataFrames, Dash, DashHtmlComponents, DashCoreComponents, PlotlyJS


df4 = DataFrame(Dict(("Col $(i)" => rand(30)) for i = 1:6))

function create_figure(df4, x_col, y_col, selectedpoints, selectedpoints_local)
    if selectedpoints_local != nothing
        ranges = selectedpoints_local[:range]
        selection_bounds = Dict(
            "x0" => ranges[:x][1],
            "x1" => ranges[:x][2],
            "y0" => ranges[:y][1],
            "x0" => ranges[:y][2],
        )
    else
        selection_bounds = Dict(
            "x0" => minimum(df4[:, x_col][1]),
            "x1" => minimum(df4[:, x_col][2]),
            "y0" => minimum(df4[:, y_col][1]),
            "x0" => minimum(df4[:, x_col][2]),
        )
    end

    return Plot(
        df4,
        x = df4[:, x_col],
        y = y_col,
        mode = "markers+text",
        marker_size = 20,
        text = 1:size(df4)[1],
        customdata = 1:size(df4)[1],
        selectedpoints = selectedpoints,
        unselected = (
            marker = (opacity = 0.3, textfont = (color = "rgba(0,0,0,0)"))
        )
    )
end

app = dash()

app.layout = html_div() do
    html_div(
        dcc_graph(id = "graph1"),
        style = (width = "32%", display = "inline-block"),
    ),
    html_div(
        dcc_graph(id = "graph2"),
        style = (width = "32%", display = "inline-block"),
    ),
    html_div(
        dcc_graph(id = "graph3"),
        style = (width = "32%", display = "inline-block"),
    )
end

callback!(
    app,
    Output("graph1", "figure"),
    Output("graph2", "figure"),
    Output("graph3", "figure"),
    Input("graph1", "selectedData"),
    Input("graph2", "selectedData"),
    Input("graph3", "selectedData"),
) do selection1, selection2, selection3
    selectedpoints = 1:size(df4)[1]

    for selected_data in [selection1, selection2, selection3]
        if selected_data != nothing
            selectedpoints = [p[:customdata] for p in selected_data.points]
        end
    end

    return create_figure(df4, "Col 1", "Col 2", selectedpoints, selection1),
           create_figure(df4, "Col 3", "Col 4", selectedpoints, selection2),
           create_figure(df4, "Col 5", "Col 6", selectedpoints, selection3)
end

run_server(app, "0.0.0.0", debug=true)
