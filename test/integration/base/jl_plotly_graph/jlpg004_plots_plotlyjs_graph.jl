using Dash
using Plots
plotlyjs()

app = dash()
app.layout = html_div() do
    dcc_graph(id = "graph", figure = plot((1:10, 1:10))),
    html_button("draw", id = "draw"),
    html_div("", id = "status")
end

callback!(app,
          Output("graph", "figure"),
          Output("status", "children"),
          Input("draw", "n_clicks")) do nclicks
    return if isnothing(nclicks)
        no_update(), "first"
    else
        plot([(1:10, 1:10), (1:10, 1:2:20)]), "second"
    end
end

run_server(app)
