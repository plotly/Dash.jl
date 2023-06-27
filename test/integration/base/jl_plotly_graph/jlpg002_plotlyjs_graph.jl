using Dash
using PlotlyJS
app = dash()
app.layout = html_div() do
    dcc_graph(id = "graph",
        figure = plot(scatter(x=1:10, y = 1:20))
    ),
    html_button("draw", id = "draw"),
    html_div("", id = "status")
end

callback!(app, Output("graph", "figure"), Output("status", "children"), Input("draw", "n_clicks")) do nclicks
    p = isnothing(nclicks) ?
           no_update() :
           plot([scatter(x=1:10, y = 1:10), scatter(x=1:10, y = 1:2:20)])
    status = isnothing(nclicks) ? "first" : "second"
    return (p, status)
end

run_server(app)
