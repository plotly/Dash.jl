module Dashboards
import HTTP, JSON2
using MacroTools
include("ComponentPackages.jl")
include("ComponentMetas.jl")
include("Components.jl")

import .ComponentPackages
using .ComponentMetas
using .Components

export Dash, Component, ComponentContainer, @use, <|, @props_str, @callid_str, callback!

ComponentPackages.@reg_components()

const IdProp = Tuple{Symbol, Symbol}

struct CallbackId
    input ::Vector{IdProp}
    state ::Vector{IdProp}
    output ::Vector{IdProp}
end

Base.convert(::Type{Vector{IdProp}}, v::IdProp) = [v]

CallbackId(;input ::Union{Vector{IdProp}, IdProp},  output ::Union{Vector{IdProp}, IdProp}, state ::Union{Vector{IdProp}, IdProp} = Vector{IdProp}()) = CallbackId(input, state, output)

struct Callback
    func ::Function
    id ::CallbackId
end

struct Dash
    name ::String
    layout ::Component
    callbacks ::Dict{Symbol, Callback}
    external_stylesheets ::Vector{String}
    routes_prefix ::String
    function Dash(name::String, layout::Component; external_stylesheets ::Vector{String} = Vector{String}(), routes_prefix="")
        new(name, layout, Dict{Symbol, Callback}(), external_stylesheets, routes_prefix)
    end    
end

function Dash(layout::Function, name::String;  external_stylesheets ::Vector{String} = Vector{String}(), routes_prefix="")
    Dash(name, layout(), external_stylesheets=external_stylesheets, routes_prefix=routes_prefix)
end

function parse_props(s)
    function make_prop(part) 
        m = match(r"^(?<id>[A-Za-z]+[\w\-\:\.]*)\.(?<prop>[A-Za-z]+[\w\-\:\.]*)$", strip(part))
        if isnothing(m)
            error("expected <id>.<property>[,<id>.<property>...] in $(part)")
        end
        return (Symbol(m[:id]), Symbol(m[:prop]))
    end    

    props_parts = split(s, ",", keepempty = false)
    
    return map(props_parts) do part
        return make_prop(part)
    end    
end
macro props_str(s)        
    return parse_props(s)
end

macro callid_str(s)
    rex = r"(\{(?<state>.*)\})?(?<input>.*)=>(?<output>.*)"ms
    m = match(rex, s)
    if isnothing(m)
        error("expected {state} input => output")
    end
    input = parse_props(strip(m[:input]))
    output = parse_props(strip(m[:output]))
    state = isnothing(m[:state]) ? Vector{IdProp}() : parse_props(strip(m[:state]))
    return CallbackId(input, state, output) 
end

idprop_string(idprop::IdProp) = "$(idprop[1]).$(idprop[2])"


function output_string(id::CallbackId)
    if length(id.output) == 1
        return idprop_string(id.output[1])
    end
    return ".." *
    join(map(idprop_string, id.output), "...") *
    ".."
end

function callback!(func::Function, app::Dash, id::CallbackId)
    
    for out in id.output
        if any(x->out in x.id.output, values(app.callbacks))
            error("output \"$(out)\" already registered")
        end
    end

    out_symbol = Symbol(output_string(id))
        
    push!(app.callbacks, out_symbol => Callback(func, id))
end

function index_page(app::Dash)
    metas = ["""<meta http-equiv="X-UA-Compatible" content="IE=edge">""", """<meta charset="UTF-8">"""]
    title = app.name
    css = join(map(app.external_stylesheets) do s 
        """<link rel="stylesheet" href="$(s)">"""    
    end, "\n"
    )
        
    app_entry = """
        <div id="react-entry-point">
            <div class="_dash-loading">
                Loading...
            </div>
        </div>
    """
    config = (
        url_base_pathname = nothing,
        requests_pathname_prefix = "/$(app.routes_prefix)",
        ui = true,
        props_check = true,
        show_undo_redo = false
    )
    
    scripts = ComponentPackages.@components_js_include

    """<!DOCTYPE html>
    <html>
        <head>
            $(join(metas, ""))
            <title>$(title)</title>            
            $(css)
        </head>
        <body>
            $(app_entry)
            <footer>
            <script id="_dash-config" type="application/json">$(JSON2.write(config))</script>
            $scripts
            <script id="_dash-renderer" type="application/javascript">var renderer = new DashRenderer();</script>
            </footer>
        </body>
    </html>"""
end

function dependencies_json(app::Dash)
    id_prop_named(p::IdProp) = (id = p[1], property = p[2])
    result = map(values(app.callbacks)) do dep
        (inputs = id_prop_named.(dep.id.input),
        state = id_prop_named.(dep.id.state),
        output = output_string(dep.id)
        )
    end
    return JSON2.write(result)
end

function process_callback(app::Dash, body::String)
    params = JSON2.read(body)
    output = Symbol(params[:output])
    if !haskey(app.callbacks, output)
        return []
    end
    args = []
    if haskey(params, :state)
        append!(args, map(x->x[:value], params.state))
    end
    if haskey(params, :inputs)
        append!(args, map(x->x[:value], params.inputs))
    end    
    res = app.callbacks[output].func(args...)
    if length(app.callbacks[output].id.output) == 1
        return Dict(
            :response => Dict(
                :props => Dict(
                    Symbol(app.callbacks[output].id.output[1][2]) => res
                )
            )
        )
    end
    response = Dict{Symbol, Any}()
    for (ind, out) in enumerate(app.callbacks[output].id.output)
        push!(response, 
        Symbol(out[1]) => Dict(
            Symbol(out[2]) => res[ind]
        )
        )
    end
    return Dict(:response=>response, :multi=>true)

end

function make_handler(app::Dash)
    function (req::HTTP.Request)
        uri = HTTP.URI(req.target)
        ComponentPackages.@register_js_sources(uri.path, app.routes_prefix)
        if uri.path == "/"
            return HTTP.Response(200, index_page(app)) 
        end
        if uri.path == "/$(app.routes_prefix)_dash-layout"
            return HTTP.Response(200, ["Content-Type" => "application/json"], body = JSON2.write(app.layout)) 
        end
        if uri.path == "/$(app.routes_prefix)_dash-dependencies"
            return HTTP.Response(200, ["Content-Type" => "application/json"], body = dependencies_json(app)) 
        end
        if uri.path == "/$(app.routes_prefix)_dash-update-component" && req.method == "POST"            
            return HTTP.Response(200, ["Content-Type" => "application/json"],
                body = JSON2.write(
                    process_callback(app, String(req.body))
                )
             ) 
        end
        return HTTP.Response(404)
    end
end

function test()
    app = Dash("Test") do
        html_div() do
        
            dcc_input(id="graphTitle", value="Let's Dance!", type = "text"),
            html_div(id="outputID"),
            html_div(id="outputID2"),
            dcc_graph(id="graph",
                figure = (
                    data = [(x = [1,2,3], y = [3,2,8], type="bar")],
                    layout = Dict(:title => "Graph")
                )
            )
                    
        end
    end
    callback!(app, callid"{graphTitle.type} graphTitle.value => outputID.children, outputID2.children") do type, value
        return ("$(type)....$(value)", value)
    end
    h = make_handler(app)
    HTTP.serve(h, HTTP.Sockets.localhost, 8080)
end

end # module