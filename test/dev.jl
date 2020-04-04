using Test
using Dash
using JSON2
@testset "dev" begin
external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]

styles = (
    pre = (
        border = "thin lightgrey solid",
        overflowX = "scroll"
    ),
)

app = dash("Dash Layout", external_stylesheets=external_stylesheets) 
app.layout = html_div() do
        dcc_graph(
            id = "basic-interactions",
            figure = (
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
            )
        ),
        html_div(className="three columns") do
            dcc_markdown() do
                """**Hover Data**
                Mouse over values in the graph."""
            end,
            html_pre(id="hover-data", style=styles.pre)
        end,
        html_div(className="three columns") do
            dcc_markdown() do
                """**Click Data**
                Click on points in the graph."""
            end,
            html_pre(id="click-data", style=styles.pre)
        end,
        html_div(className="three columns") do
            dcc_markdown() do
                """**Selection Data**
                Choose the lasso or rectangle tool in the graph's menu
                bar and then select points in the graph.
                Note that if `layout.clickmode = 'event+select'`, selection data also
                accumulates (or un-accumulates) selected data if you hold down the shift
                button while clicking."""
            end,
            html_pre(id="selected-data", style=styles.pre)
        end,
        html_div(className="three columns") do
            dcc_markdown() do
                """**Zoom and Relayout Data**
                Click and drag on the graph to zoom or click on the zoom
                buttons in the graph's menu bar.
                Clicking on legend items will also fire
                this event."""
            end,
            html_pre(id="relayout-data", style=styles.pre)
        end
    end


function pretty_json(t)
    io = IOBuffer()
    JSON2.pretty(io, JSON2.write(t), offset = 2)
    return String(take!(io))
end

callback!(app, callid"""basic-interactions.hoverData => hover-data.children""") do hover_data
    pretty_json(hover_data)
end
callback!(app, callid"""basic-interactions.clickData => click-data.children""") do click_data
    pretty_json(click_data)
end
callback!(app, callid"""basic-interactions.selectedData => selected-data.children""") do selected_data
    pretty_json(selected_data)
end
callback!(app, callid"""basic-interactions.relayoutData => relayout-data.children""") do relayout_data
    pretty_json(relayout_data)
end

run_server(app)
end
