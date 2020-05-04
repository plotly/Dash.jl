module Dash
import HTTP, JSON2, CodecZlib, MD5
using MacroTools
const ROOT_PATH = realpath(joinpath(@__DIR__, ".."))
include("Components.jl")
include("Front.jl")


import .Front

using .Components

export dash, Component, Front, <|, @callid_str, CallbackId, callback!,
set_debug!,
run_server, PreventUpdate, no_update, @var_str



#ComponentPackages.@reg_components()
include("env.jl")
include("utils.jl")
include("devtools.jl")
include("app.jl")
include("resources/registry.jl")
include("resources/application.jl")
include("config.jl")
include("handlers.jl")

@doc """
    module Dash

Julia backend for [Plotly Dash](https://github.com/plotly/dash)

# Examples
```julia

using Dash
app = dash("Test", external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"]) do
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
callback!(app, callid"{graphTitle.type} graphTitle.value => outputID.children") do type, value
    "You've entered: '\$(value)' into a '\$(type)' input control"
end
callback!(app, callid"graphTitle.value => graph.figure") do value
    (
        data = [
            (x = [1,2,3], y = abs.(randn(3)), type="bar"),
            (x = [1,2,3], y = abs.(randn(3)), type="scatter", mode = "lines+markers", line = (width = 4,))                
        ],
        layout = (title = value,)
    )
end
handle = make_handler(app, debug = true)
run_server(handle, HTTP.Sockets.localhost, 8080)
```

""" Dashboards


"""
    run_server(app::DashApp, host = HTTP.Sockets.localhost, port = 8080; debug::Bool = false)

Run Dash server

#Arguments
- `app` - Dash application
- `host` - host
- `port` - port
- `debug::Bool = false` - Enable/disable all the dev tools

#Examples
```jldoctest
julia> app = dash("Test") do
    html_div() do
        html_h1("Test Dashboard")
    end
end
julia>
julia> run_server(handler,  HTTP.Sockets.localhost, 8080)
```

"""
function run_server(app::DashApp, host = HTTP.Sockets.localhost, port = 8080;
            debug = nothing, ui = nothing,
            props_check = nothing,
            serve_dev_bundles = nothing,
            hot_reload = nothing,
            hot_reload_interval = nothing,
            hot_reload_watch_interval = nothing,
            hot_reload_max_retry = nothing,
            silence_routes_logging = nothing,
            prune_errors = nothing
            )
    @env_default!(debug, Bool, false)
    set_debug!(app, 
        debug = debug,
        props_check = props_check,
        serve_dev_bundles = serve_dev_bundles,
        hot_reload = hot_reload,
        hot_reload_interval = hot_reload_interval,
        hot_reload_watch_interval = hot_reload_watch_interval,
        hot_reload_max_retry = hot_reload_max_retry,
        silence_routes_logging = silence_routes_logging,
        prune_errors = prune_errors
    )
    handler = make_handler(app);
    @info "started"
    HTTP.serve(handler, host, port)
end


end # module