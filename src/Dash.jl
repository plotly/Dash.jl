module Dash
components = [1,2,3,4,5]
import HTTP, JSON2
using MacroTools
include("ComponentPackages.jl")
include("ComponentMetas.jl")
include("Components.jl")
include("Front.jl")

import .ComponentPackages
import .Front
using .ComponentMetas
using .Components

export dash, Component, Front, @use, <|, @callid_str, CallbackId, callback!,
run_server, PreventUpdate, no_update, @wildprop

ComponentPackages.@reg_components()
include("utils.jl")
include("config.jl")
include("app.jl")
include("index_page.jl")
include("handlers.jl")


macro test()

end

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

# Available components
$(ComponentPackages.component_doc_list())
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
function run_server(app::DashApp, host = HTTP.Sockets.localhost, port = 8080; debug = false)
    handler = make_handler(app, debug = debug);
    HTTP.serve(handler, host, port)
end


end # module