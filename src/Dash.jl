module Dash
import HTTP, JSON2, CodecZlib, MD5
using Sockets
const ROOT_PATH = realpath(joinpath(@__DIR__, ".."))
include("Components.jl")
include("Front.jl")
include("HttpHelpers/HttpHelpers.jl")
import .Front
using .Components
using .HttpHelpers

export dash, Component, Front, callback!,
enable_dev_tools!, ClientsideFunction,
run_server, PreventUpdate, no_update, @var_str,
Input, Output, State, make_handler, callback_context

include("Contexts/Contexts.jl")
include("env.jl")
include("utils.jl")
include("app.jl")
include("resources/registry.jl")
include("resources/application.jl")
include("handlers.jl")
include("server.jl")

@doc """
    module Dash

Julia backend for [Plotly Dash](https://github.com/plotly/dash)

# Examples
```julia

using Dash
using DashHtmlComponents
using DashCoreComponents
app = dash(external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"]) do
    html_div() do
        dcc_input(id="graphTitle", value="Let's Dance!", type = "text"),
        html_div(id="outputID"),            
        dcc_graph(id="graph",
            figure = (
                data = [(x = [1,2,3], y = [3,2,8], type="bar")],
                layout = Dict(:title => "Graph")
            )
        )
                
    end
end
callback!(app, Output("outputID", "children"), Input("graphTitle","value"), State("graphTitle","type")) do value, type
    "You've entered: '\$(value)' into a '\$(type)' input control"
end
callback!(app, Output("graph", "figure"), Input("graphTitle", "value")) do value
    (
        data = [
            (x = [1,2,3], y = abs.(randn(3)), type="bar"),
            (x = [1,2,3], y = abs.(randn(3)), type="scatter", mode = "lines+markers", line = (width = 4,))                
        ],
        layout = (title = value,)
    )
end
run_server(app, HTTP.Sockets.localhost, 8050)
```

""" Dash



end # module
