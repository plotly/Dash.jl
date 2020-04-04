function index_page(app::DashApp; debug = false)
    metas = ["""<meta http-equiv="X-UA-Compatible" content="IE=edge">""", """<meta charset="UTF-8">"""]
    title = app.name
    css = join(map(app.external_stylesheets) do s 
        """<link rel="stylesheet" href="$(s)">"""    
    end, "\n"
    )
    external_scripts = join(map(app.external_scripts) do s 
        """<script src="$(s)" crossorigin="anonymous"></script>"""
    end, "\n")
        
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
            $external_scripts
            $scripts
            <script id="_dash-renderer" type="application/javascript">var renderer = new DashRenderer();</script>
            </footer>
        </body>
    </html>"""
end

function dependencies_json(app::DashApp)
    id_prop_named(p::IdProp) = (id = p[1], property = p[2])
    result = map(values(app.callbacks)) do dep
        (inputs = id_prop_named.(dep.id.input),
        state = id_prop_named.(dep.id.state),
        output = output_string(dep.id)
        )
    end
    return JSON2.write(result)
end

function process_callback(app::DashApp, body::String)
    params = JSON2.read(body)
    output = Symbol(params[:output])
    if !haskey(app.callbacks, output)
        return []
    end
    convert_values(inputs) = map(inputs) do x
        return get(x, :value, nothing)        
    end 
    args = []
    if app.callbacks[output].pass_changed_props
        push!(args, params[:changedPropIds])
    end
    if haskey(params, :state)
        append!(args, convert_values(params.state))        
    end
    if haskey(params, :inputs)
        append!(args, convert_values(params.inputs))        
    end    
    
    res = app.callbacks[output].func(args...)
    if length(app.callbacks[output].id.output) == 1
        if !(res isa NoUpdate)
            return Dict(
                :response => Dict(
                    :props => Dict(
                        Symbol(app.callbacks[output].id.output[1][2]) => Front.to_dash(res)
                    )
                )
            )
        else
            throw(PreventUpdate())
        end
    end
    response = Dict{Symbol, Any}()
    for (ind, out) in enumerate(app.callbacks[output].id.output)
        if !(res[ind] isa NoUpdate)
            push!(response, 
            Symbol(out[1]) => Dict(
                Symbol(out[2]) => Front.to_dash(res[ind])
            )
            )
        end
    end
    if length(response) == 0
        throw(PreventUpdate())
    end
    return Dict(:response=>response, :multi=>true)

end

function process_assets(app::DashApp, path)
    assets_path = "$(app.url_base_pathname)assets/"
    filename = joinpath(app.assets_folder, replace(path, assets_path=>""))    
    try
        return HTTP.Response(200, [], body = read(filename))
    catch
        return HTTP.Response(404)
    end
end


function make_handler(app::DashApp; debug::Bool = false)
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
            try
                return HTTP.Response(200, ["Content-Type" => "application/json"],
                    body = JSON2.write(
                        process_callback(app, String(req.body))
                    )
                )
            catch e                                
                if isa(e,PreventUpdate)                
                    return HTTP.Response(204)                                    
                else
                    rethrow(e)
                end
            end 
        end
        return HTTP.Response(404)
    end
end