module Dash
import HTTP, JSON2, CodecZlib, MD5
using Sockets
using MacroTools
const ROOT_PATH = realpath(joinpath(@__DIR__, ".."))
include("Components.jl")
include("Front.jl")
import .Front
using .Components

export dash, Component, Front, <|, @callid_str, CallbackId, callback!,
enable_dev_tools!,
run_server, PreventUpdate, no_update, @var_str



#ComponentPackages.@reg_components()
include("env.jl")
include("utils.jl")
include("app.jl")
include("resources/registry.jl")
include("resources/application.jl")
include("handlers.jl")

@doc """
    module Dash

Julia backend for [Plotly Dash](https://github.com/plotly/dash)

# Examples
```julia

using Dash
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
run_server(handle, HTTP.Sockets.localhost, 8050)
```

""" Dashboards


"""
    run_server(app::DashApp, host = HTTP.Sockets.localhost, port = 8050; debug::Bool = false)

Run Dash server

#Arguments
- `app` - Dash application
- `host` - host
- `port` - port
- `debug::Bool = false` - Enable/disable all the dev tools

#Examples
```jldoctest
julia> app = dash) do
    html_div() do
        html_h1("Test Dashboard")
    end
end
julia>
julia> run_server(handler,  HTTP.Sockets.localhost, 8050)
```

"""
function run_server(app::DashApp, host = HTTP.Sockets.localhost, port = 8050;
            debug = nothing, 
            dev_tools_ui = nothing,
            dev_tools_props_check = nothing,
            dev_tools_serve_dev_bundles = nothing,
            dev_tools_hot_reload = nothing,
            dev_tools_hot_reload_interval = nothing,
            dev_tools_hot_reload_watch_interval = nothing,
            dev_tools_hot_reload_max_retry = nothing,
            dev_tools_silence_routes_logging = nothing,
            dev_tools_prune_errors = nothing
            )
    @env_default!(debug, Bool, false)
    enable_dev_tools!(app, 
        debug = debug,
        dev_tools_ui = dev_tools_ui,
        dev_tools_props_check = dev_tools_props_check,
        dev_tools_serve_dev_bundles = dev_tools_serve_dev_bundles,
        dev_tools_hot_reload = dev_tools_hot_reload,
        dev_tools_hot_reload_interval = dev_tools_hot_reload_interval,
        dev_tools_hot_reload_watch_interval = dev_tools_hot_reload_watch_interval,
        dev_tools_hot_reload_max_retry = dev_tools_hot_reload_max_retry,
        dev_tools_silence_routes_logging = dev_tools_silence_routes_logging,
        dev_tools_prune_errors = dev_tools_prune_errors
    )
    main_func = () -> begin
        ccall(:jl_exit_on_sigint, Cvoid, (Cint,), 0)
        handler = make_handler(app);
        try
            task = @async HTTP.serve(handler, host, port)
            @info string("Running on http://", host, ":", port)
            wait(task)
        catch e
            if e isa InterruptException
                @info "exited"
            else
                rethrow(e)
            end

        end
    end
    if get_devsetting(app, :hot_reload)
        hot_restart(main_func, check_interval = get_devsetting(app, :hot_reload_watch_interval))
    else
        main_func()
    end
end

end # module
