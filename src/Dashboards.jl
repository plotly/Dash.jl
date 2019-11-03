module Dashboards
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

export Dash, Component, Front, @use, <|, @callid_str, CallbackId, callback!, link_type!, make_handler

ComponentPackages.@reg_components()

@doc """
    module Dashboards

Julia backend for [Plotly Dash](https://github.com/plotly/dash)

# Examples
```julia
import HTTP
using Dashboards
app = Dash("Test", external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"]) do
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
HTTP.serve(handle, HTTP.Sockets.localhost, 8080)
```

# Available components
$(ComponentPackages.component_doc_list())
""" Dashboards

const IdProp = Tuple{Symbol, Symbol}

struct CallbackId
    state ::Vector{IdProp}
    input ::Vector{IdProp}
    output ::Vector{IdProp}
end

Base.convert(::Type{Vector{IdProp}}, v::IdProp) = [v]

CallbackId(;input ::Union{Vector{IdProp}, IdProp},  output ::Union{Vector{IdProp}, IdProp}, state ::Union{Vector{IdProp}, IdProp} = Vector{IdProp}()) = CallbackId(state, input, output)

struct Callback
    func ::Function
    id ::CallbackId
end

struct ProperiesType

end

"""
    struct Dash <: Any

Representation of Dash application
"""
struct Dash
    name ::String
    layout ::Component
    callbacks ::Dict{Symbol, Callback}
    external_stylesheets ::Vector{String}
    url_base_pathname ::String
    assets_folder ::String
    callable_components ::Dict{Symbol, Component}
    type_links ::Dict{Symbol, Dict{Symbol, Type}}
    function Dash(name::String, layout::Component; external_stylesheets ::Vector{String} = Vector{String}(), url_base_pathname="/", assets_folder::String = "assets")
        new(name, layout, Dict{Symbol, Callback}(), external_stylesheets, url_base_pathname, assets_folder, Components.collect_with_ids(layout), Dict{Symbol, Dict{Symbol, Type}}())
    end    
end


"""
    Dash(layout_maker::Function, name::String; external_stylesheets ::Vector{String} = Vector{String}(), url_base_pathname::String="/")::Dash

Construct a Dash app using callback for layout creation

# Arguments
- `layout_maker::Function` - function for layout creation. Must has signature ()::Component
- `name::String` - Dashboard name
- `external_stylesheets::Vector{String} = Vector{String}()` - vector of external css urls 
- `url_base_pathname::String="/"` - base url path for dashboard, default "/" 
- `assets_folder::String` - a path, relative to the current working directory,
for extra files to be used in the browser. Default `"assets"`

# Examples
```jldoctest
julia> app = Dash("Test") do
    html_div() do
        html_h1("Test Dashboard")
    end
end
```
"""
function Dash(layout_maker::Function, name::String;  external_stylesheets ::Vector{String} = Vector{String}(), url_base_pathname="/", assets_folder::String = "assets")
    Dash(name, layout_maker(), external_stylesheets=external_stylesheets, url_base_pathname=url_base_pathname, assets_folder = assets_folder)
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

"""
    @callid_str"

Macro for crating Dash CallbackId.
Parse string in form "[{State1[, ...]}] Input1[, ...] => Output1[, ...]"

#Examples
```julia
    id1 = callid"{inputDiv.children} input.value => output1.value, output2.value"
```
"""
macro callid_str(s)
    rex = r"(\{(?<state>.*)\})?(?<input>.*)=>(?<output>.*)"ms
    m = match(rex, s)
    if isnothing(m)
        error("expected {state} input => output")
    end
    input = parse_props(strip(m[:input]))
    output = parse_props(strip(m[:output]))
    state = isnothing(m[:state]) ? Vector{IdProp}() : parse_props(strip(m[:state]))
    return CallbackId(state, input, output) 
end

idprop_string(idprop::IdProp) = "$(idprop[1]).$(idprop[2])"

function check_idprop(app::Dash, id::IdProp)
    if !haskey(app.callable_components, id[1])
        error("The layout havn't component with id `$(id[1])]`")
    end
    if !is_prop_available(app.callable_components[id[1]], id[2])
        error("The component with id `$(id[1])` havn't property `$(id[2])``")
    end
end

function output_string(id::CallbackId)
    if length(id.output) == 1
        return idprop_string(id.output[1])
    end
    return ".." *
    join(map(idprop_string, id.output), "...") *
    ".."
end

"""
    callback!(func::Function, app::Dash, id::CallbackId)

Create a callback that updates the output by calling function `func`.

#Examples
```julia
app = Dash("Test") do
    html_div() do
        dcc_input(id="graphTitle", value="Let's Dance!", type = "text"),
        html_div(id="outputID"),
        html_div(id="outputID2")

    end
end
callback!(app, CallbackId(
    state = [(:graphTitle, :type)],
    input = [(:graphTitle, :value)],
    output = [(:outputID, :children), (:outputID2, :children)]
    )
    ) do stateType, inputValue
    return (stateType * "..." * inputValue, inputValue)
end
```
You can use macro `callid` string macro for make CallbackId : 
```julia
callback!(app, callid"{graphTitle.type} graphTitle.value => outputID.children, outputID2.children") do stateType, inputValue

    return (stateType * "..." * inputValue, inputValue)
end
```    
"""
function callback!(func::Function, app::Dash, id::CallbackId)    
    for out in id.output
        if any(x->out in x.id.output, values(app.callbacks))
            error("output \"$(out)\" already registered")
        end
    end

    foreach(x->check_idprop(app,x), id.state)
    foreach(x->check_idprop(app,x), id.input)
    foreach(x->check_idprop(app,x), id.output)
    
    out_symbol = Symbol(output_string(id))
        
    push!(app.callbacks, out_symbol => Callback(func, id))
end

function callback_argument_type(app::Dash, id::AbstractString, prop::AbstractString)::Type
    id_sym = Symbol(id)
    prop_sym = Symbol(prop)
    if haskey(app.type_links, id_sym) && haskey(app.type_links[id_sym], prop_sym)
        return app.type_links[id_sym][prop_sym]
    end
    return Any
end

function push_link_type!(app::Dash, idprop::IdProp, t::Type)
    check_idprop(app, idprop)
    if !haskey(app.type_links, idprop[1])
        push!(app.type_links, idprop[1] => Dict{Symbol, Type}())
    end
    app.type_links[idprop[1]][idprop[2]] = t
end

function link_type!(app::Dash, idprop::AbstractString, t::Type)
    m = match(r"^((?<id>[A-Za-z]+[\w\-\:\.]*)|(?<any_id>\*))\.(?<prop>[A-Za-z]+[\w\-\:\.]*)$", strip(idprop))
    if isnothing(m)
        error("expected <id>.<property> or *.<property>")
    end
    
    if !isnothing(m[:id])
        push_link_type!(app, (Symbol(m[:id]), Symbol(m[:prop])), t)
    elseif !isnothing(m[:any_id])
        prop = Symbol(m[:prop])
        for (id, comp) in pairs(app.callable_components)
            if is_prop_available(comp, prop)
                push_link_type!(app, (id, prop), t)
            end
        end
    else
        @assert false "not reachable"
    end

end

function index_page(app::Dash; debug = false)
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
        url_base_pathname = "$(app.url_base_pathname)",
        requests_pathname_prefix = "$(app.url_base_pathname)",
        ui = true,
        props_check = debug,
        show_undo_redo = false
    )
    
    scripts = ComponentPackages.components_js_include(app.url_base_pathname, debug = debug)

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
    convert_values(inputs) = map(inputs) do x
        type = callback_argument_type(app, x.id, x.property)
        return Front.from_dash(type, x.value)
    end 
    args = []
    if haskey(params, :state)
        append!(args, convert_values(params.state))
        #append!(args, map(x->haskey(x, :value) ? x[:value] : nothing, params.state))
    end
    if haskey(params, :inputs)
        append!(args, convert_values(params.inputs))
        #append!(args, map(x->haskey(x, :value) ? x[:value] : nothing, params.inputs))
    end    
    
    res = app.callbacks[output].func(args...)
    if length(app.callbacks[output].id.output) == 1
        return Dict(
            :response => Dict(
                :props => Dict(
                    Symbol(app.callbacks[output].id.output[1][2]) => Front.to_dash(res)
                )
            )
        )
    end
    response = Dict{Symbol, Any}()
    for (ind, out) in enumerate(app.callbacks[output].id.output)
        push!(response, 
        Symbol(out[1]) => Dict(
            Symbol(out[2]) => Front.to_dash(res[ind])
        )
        )
    end
    return Dict(:response=>response, :multi=>true)

end

function process_assets(app::Dash, path)
    assets_path = "$(app.url_base_pathname)assets/"
    filename = joinpath(app.assets_folder, replace(path, assets_path=>""))    
    try
        return HTTP.Response(200, [], body = read(filename))
    catch
        return HTTP.Response(404)
    end
end

"""
    make_handler(app::Dash; debug = false)

Make handler for routing Dash application in HTTP package 

#Arguments
- `app::Dash` - Dash application
- `debug::Bool = false` - Enable/disable all the dev tools

#Examples
```jldoctest
julia> app = Dash("Test") do
    html_div() do
        html_h1("Test Dashboard")
    end
end
julia> handler = make_handler(app)
julia> HTTP.serve(handler, HTTP.Sockets.localhost, 8080)
```

"""
function make_handler(app::Dash; debug::Bool = false)
    function (req::HTTP.Request)
        uri = HTTP.URI(req.target)
        ComponentPackages.@register_js_sources(uri.path, app.url_base_pathname)
        if uri.path == "$(app.url_base_pathname)"
            return HTTP.Response(200, index_page(app, debug = debug)) 
        end
        if uri.path == "$(app.url_base_pathname)_dash-layout"
            return HTTP.Response(200, ["Content-Type" => "application/json"], body = JSON2.write(app.layout)) 
        end
        if uri.path == "$(app.url_base_pathname)_dash-dependencies"
            return HTTP.Response(200, ["Content-Type" => "application/json"], body = dependencies_json(app)) 
        end
        if startswith(uri.path, "$(app.url_base_pathname)assets/")
            return process_assets(app, uri.path)
        end
        if uri.path == "$(app.url_base_pathname)_dash-update-component" && req.method == "POST"            
            return HTTP.Response(200, ["Content-Type" => "application/json"],
                body = JSON2.write(
                    process_callback(app, String(req.body))
                )
             ) 
        end
        return HTTP.Response(404)
    end
end


end # module