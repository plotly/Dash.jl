module Dash
using DashBase
import HTTP, JSON2, CodecZlib, MD5
using Sockets
const ROOT_PATH = realpath(joinpath(@__DIR__, ".."))
const RESOURCE_PATH = realpath(joinpath(ROOT_PATH, "resources"))
include("exceptions.jl")
include("Components.jl")
include("Front.jl")
include("HttpHelpers/HttpHelpers.jl")

using .HttpHelpers

export dash, Component, Front, callback!,
enable_dev_tools!, ClientsideFunction,
run_server, PreventUpdate, no_update, @var_str,
Input, Output, State, make_handler, callback_context,
ALL, MATCH, ALLSMALLER, DashBase

include("Contexts/Contexts.jl")
include("env.jl")
include("utils.jl")
include("app.jl")
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


function __init__()
    DashBase.main_registry().dash_dependency = (
        dev = ResourcePkg(
            "dash_renderer",
            RESOURCE_PATH, version = "1.5.0",
            [
                Resource(
                relative_package_path = "react@16.13.0.js",
                external_url = "https://unpkg.com/react@16.13.0/umd/react.development.js"
                ),
                Resource(
                    relative_package_path = "react-dom@16.13.0.js",
                    external_url = "https://unpkg.com/react-dom@16.13.0/umd/react-dom.development.js"
                ),
                Resource(
                    relative_package_path = "polyfill@7.8.7.min.js",
                    external_url = "https://unpkg.com/@babel/polyfill@7.8.7/dist/polyfill.min.js"
                ),
                Resource(
                    relative_package_path = "prop-types@15.7.2.js",
                    external_url = "https://unpkg.com/prop-types@15.7.2/prop-types.js",
                ),
            ]
        ),
        prod = ResourcePkg(
            "dash_renderer",
            RESOURCE_PATH, version = "1.2.2",
            [
                Resource(
                relative_package_path = "react@16.13.0.min.js",
                external_url = "https://unpkg.com/react@16.13.0/umd/react.production.min.js"
                ),
                Resource(
                    relative_package_path = "react-dom@16.13.0.min.js",
                    external_url = "https://unpkg.com/react-dom@16.13.0/umd/react-dom.production.min.js"
                ),
                Resource(
                    relative_package_path = "polyfill@7.8.7.min.js",
                    external_url = "https://unpkg.com/@babel/polyfill@7.8.7/dist/polyfill.min.js"
                ),
                Resource(
                    relative_package_path = "prop-types@15.7.2.min.js",
                    external_url = "https://unpkg.com/prop-types@15.7.2/prop-types.min.js"
                ),
            ]
        )
    )

    DashBase.main_registry().dash_renderer = ResourcePkg(
        "dash_renderer",
        RESOURCE_PATH, version = "1.5.0",
        [
            Resource(
                relative_package_path = "dash_renderer.min.js",
                dev_package_path = "dash_renderer.dev.js",
                external_url = "https://unpkg.com/dash-renderer@1.5.0/dash_renderer/dash_renderer.min.js"
            ),
            Resource(
                relative_package_path = "dash_renderer.min.js.map",
                dev_package_path = "dash_renderer.dev.js.map",
                dynamic = true,
            ),
        ]
    )


end


end # module
