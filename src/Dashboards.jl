module Dashboards
import HTTP, JSON2
using MacroTools
include("ComponentPackages.jl")
include("ComponentMetas.jl")
include("Components.jl")

import .ComponentPackages
using .ComponentMetas
using .Components

export Dash, Component, @use

struct Dependency
    input
    state 
    output
    func::Function
end

struct Dash
    name ::String
    layout ::Function
    dependencies ::Vector{Dependency}
    external_stylesheets ::Vector{String}
    routes_prefix ::String
    function Dash(name::String, layout::Function; external_stylesheets ::Vector{String} = Vector{String}(), routes_prefix="")
        new(name, layout, Vector{Dependency}(), external_stylesheets, routes_prefix)
    end    
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

function make_handler(app::Dash)
    function (req::HTTP.Request)
        uri = HTTP.URI(req.target)
        
    end
end

macro use(name, expr)
    @capture(expr, pack_.comp_(props__)) || error("expected <struct_name>:<package>.<component>(<properties>...)")
    
    components = ComponentPackages.load_package_components(pack)
    if !haskey(components, comp)
        error("undefined component $(comp) in package $(pack)")
    end
    component = components[comp]
            
    for prop in props
        if !haskey(component.properties, prop)
            error("undefined property $(prop) for component $(name)")
        end
    end
    
    namespace = ComponentPackages.package_namespace(pack)
    type_name = string(comp)
    props_tuple = :(NamedTuple{$(props...,), Tuple{$(map(x->:(Any), props)...)}})
    

    if any(x->x==:children, props)
        children_prop = :(children::Any)
        filter!(x->x!=:children, props)        
        return esc(quote
            struct $(name) <: Dashboards.Components.ComponentContainer
                type::String
                namespace::String
                props::$(props_tuple)                
                function $(name)(children::Any = nothing; $(map(v->Expr(:kw, :($(v)), nothing), props)...))
                    new($(type_name), $(namespace), (children = children, $(map(v->:($(v)=$(v)), props)...),))
                end
            end
                        
        end)        
    else
        return esc(quote
            struct $(name) <: Dashboards.Components.Component
                type::String
                namespace::String
                props::$(props_tuple)
                function $(name)(;$(map(v->Expr(:kw, :($(v)), nothing), props)...))
                    new($(type_name), $(namespace), ($(map(v->:($(v)=$(v)), props)...),))
                end
            end            
        end)
    end    
end



macro setup(router)
    quote
        HTTP.@register($(esc(router)), "GET", "/", index)
        Dashboards.ComponentPackages.@register_js_sources($(esc(router)), "")
        HTTP.@register($(esc(router)), "GET", $(prefix)*"_dash-dependencies", 
        (req::HTTP.Request) -> HTTP.Response(200, ["Content-Type" => "application/json"], body = JSON2.write([]))
        )
    end        
end

macro make_layout(name, main_component)
    quote
        function $(esc(name))($(esc(:req))::HTTP.Request)
            HTTP.Response(200, ["Content-Type" => "application/json"], body = JSON2.write($(esc(main_component))))
        end        
    end
end

macro layout(router, main_component)    
    quote
        HTTP.@register($(esc(router)), "GET", $(prefix)*"_dash-layout", 
        (req::HTTP.Request) -> HTTP.Response(200, ["Content-Type" => "application/json"], body = JSON2.write($(esc(main_component))))
        )
    end    
end

macro register(router, app, prefix = "")    
    quote
        HTTP.@register($(esc(router)), "GET", "/", function (req::HTTP.Request)             
            HTTP.Response(200, index_page($(esc(app))))
        end
        )
        Dashboards.ComponentPackages.@register_js_sources($(esc(router)), "")
        HTTP.@register($(esc(router)), "GET", $(prefix)*"_dash-dependencies", 
            (req::HTTP.Request) -> HTTP.Response(200, ["Content-Type" => "application/json"], body = JSON2.write([]))
        )
        HTTP.@register($(esc(router)), "GET", $(prefix)*"_dash-layout", $(esc(app)).layout)
            #(req::HTTP.Request) -> HTTP.Response(200, ["Content-Type" => "application/json"], body = $(esc(app)).layout(req))
        
    end
end

end # module
