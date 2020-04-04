const IdProp = Tuple{Symbol, Symbol}

struct CallbackId
    state ::Vector{IdProp}
    input ::Vector{IdProp}
    output ::Vector{IdProp}
    
end
CallbackId(;input ::Union{Vector{IdProp}, IdProp},
            output ::Union{Vector{IdProp}, IdProp},
            state ::Union{Vector{IdProp}, IdProp} = Vector{IdProp}()
            ) = CallbackId(state, input, output)


Base.convert(::Type{Vector{IdProp}}, v::IdProp) = [v]

struct Callback
    func ::Function
    id ::CallbackId
    pass_changed_props ::Bool
end

struct PreventUpdate <: Exception
    
end


struct NoUpdate
end

no_update() = NoUpdate()

mutable struct Layout
    component::Union{Nothing, Component}
end

"""
    struct DashApp <: Any

Representation of Dash application
"""
struct DashApp
    name ::String
    layout ::Layout
    callbacks ::Dict{Symbol, Callback}
    external_stylesheets ::Vector{String}
    external_scripts ::Vector{String}
    url_base_pathname ::String
    assets_folder ::String
    callable_components ::Dict{Symbol, Component}
    function DashApp(name::String;
        external_stylesheets ::Vector{String} = Vector{String}(),
        external_scripts ::Vector{String} = Vector{String}(),
        url_base_pathname="/",
        assets_folder::String = "assets")
        
        new(name, Layout(nothing), Dict{Symbol, Callback}(),
            external_stylesheets, external_scripts,
            url_base_pathname, assets_folder,
            Dict{Symbol, Component}()
            
            )
    end    
end

function layout!(app::DashApp, component::Component)
    Base.getfield(app, :layout).component = component
    Components.collect_with_ids!(app.layout, app.callable_components)
end

get_layout(app::DashApp) = Base.getfield(app, :layout).component

function Base.setproperty!(app::DashApp, name::Symbol, value)
    name == :layout ? layout!(app, value) : Base.setfield!(app, name, value)
end

function Base.getproperty(app::DashApp, name::Symbol)
    name == :layout ? get_layout(app) : Base.getfield(app, name)
end

    



"""
    dash(name::String; external_stylesheets ::Vector{String} = Vector{String}(), url_base_pathname::String="/")
    dash(layout_maker::Function, name::String; external_stylesheets ::Vector{String} = Vector{String}(), url_base_pathname::String="/")

Construct a dash app using callback for layout creation

# Arguments
- `layout_maker::Function` - function for layout creation. Must has signature ()::Component
- `name::String` - Dashboard name
- `external_stylesheets::Vector{String} = Vector{String}()` - vector of external css urls 
- `external_scripts::Vector{String} = Vector{String}()` - vector of external js scripts urls 
- `url_base_pathname::String="/"` - base url path for dashboard, default "/" 
- `assets_folder::String` - a path, relative to the current working directory,
for extra files to be used in the browser. Default `"assets"`

# Examples
```jldoctest
julia> app = dash("Test") do
    html_div() do
        html_h1("Test Dashboard")
    end
end
```
"""

function dash(name::String;
    external_stylesheets ::Vector{String} = Vector{String}(),
    external_scripts ::Vector{String} = Vector{String}(),
    url_base_pathname="/",
    assets_folder::String = "assets")
        result = DashApp(name,
            external_stylesheets=external_stylesheets,
            external_scripts=external_scripts,
            url_base_pathname=url_base_pathname,
            assets_folder = assets_folder
            )
    return result
end

function dash(layout_maker::Function, name::String;
      external_stylesheets ::Vector{String} = Vector{String}(),
      external_scripts ::Vector{String} = Vector{String}(),
      url_base_pathname="/",
      assets_folder::String = "assets")
    result = dash(name,
        external_stylesheets=external_stylesheets,
        external_scripts=external_scripts,
        url_base_pathname=url_base_pathname,
        assets_folder = assets_folder
        )
    layout!(result, layout_maker())
    return result
end



idprop_string(idprop::IdProp) = "$(idprop[1]).$(idprop[2])"

function check_idprop(app::DashApp, id::IdProp)
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
    callback!(func::Function, app::Dash, id::CallbackId; pass_changed_props = false)

Create a callback that updates the output by calling function `func`.

If `pass_changed_props` is true then the first argument of callback is an array of changed properties

# Examples

```julia
app = dash("Test") do
    html_div() do
        dcc_input(id="graphTitle", value="Let's Dance!", type = "text"),
        dcc_input(id="graphTitle2", value="Let's Dance!", type = "text"),
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

Using `changed_props`

```julia
callback!(app, callid"graphTitle.value, graphTitle2.value => outputID.children", pass_changed_props = true) do changed, input1, input2
    if "graphTitle.value" in changed
        return input1
    else
        return input2
    end
end
```

"""
function callback!(func::Function, app::DashApp, id::CallbackId; pass_changed_props = false)    
    for out in id.output
        if any(x->out in x.id.output, values(app.callbacks))
            error("output \"$(out)\" already registered")
        end
    end

    foreach(x->check_idprop(app,x), id.state)
    foreach(x->check_idprop(app,x), id.input)
    foreach(x->check_idprop(app,x), id.output)
    
    out_symbol = Symbol(output_string(id))
        
    push!(app.callbacks, out_symbol => Callback(func, id, pass_changed_props))
end
