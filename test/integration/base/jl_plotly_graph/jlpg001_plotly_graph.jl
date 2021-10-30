using Dash
using PlotlyBase

app = dash()
app.layout = html_div() do
    dcc_graph(id = "graph",
        figure = Plot(scatter(x=1:10, y = 1:10))
    ),
    html_button("draw", id = "draw"),
    html_div("", id = "status")
end

callback!(app, Output("graph", "figure"), Output("status", "children"), Input("draw", "n_clicks")) do nclicks
    plot = isnothing(nclicks) ?
           no_update() :
           Plot([scatter(x=1:10, y = 1:10), scatter(x=1:10, y = 1:2:20)])
    status = isnothing(nclicks) ? "first" : "second"
    return (plot, status)
end

run_server(app, dev_tools_props_check = true)