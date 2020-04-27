struct ResourcesRouter
    resources ::Dict{String, Dict{String, String}}
    ResourcesRouter() = new(Dict{String, Dict{String, String}})
end

function ResourcesRouter(app::DashApp, resources::ResourcesRegistry)
    result = ResourcesRouter()
    !get_setting(app, :serve_locally) && return result      

    eager_loading = get_setting(app, :eager_loading)

end

struct HandlerState
    index_string ::String
    dependencies_json ::String
    resources_paths ::Dict{String, Dict{String, String}}
    HandlerState(index_string, dependencies_json) = new(index_string, dependencies_json, Dict{String, Dict{String, String}}())
end

function HandlerState(app::DashApp, registry::ResourcesRegistry; debug = false)
    index_string = index_page(app, debug = debug)
    dependencies_json = dependencies_json(app)

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

function make_response(status, headers, body, compress::Bool)
    message_headers = headers

    if compress
        push!(message_headers, "Content-Encoding" => "gzip")
        body = transcode(CodecZlib.GzipCompressor, body)
    end

    response = HTTP.Response(status, body)
    for header in message_headers
        HTTP.Messages.setheader(response, header)
    end
    return response
end

function process_assets(app::DashApp, path, compress::Bool)
    assets_path = "$(app.config.routes_pathname_prefix)" * strip(app.config.assets_url_path, '/') * "/"
    filename = joinpath(app.config.assets_folder, replace(path, assets_path=>""))

    try
        file_contents = read(filename)
        mimetype = HTTP.sniff(file_contents)
        use_gzip = compress && occursin(r"text|javascript", mimetype)
        headers = ["Content-Type" => mimetype]
        return make_response(200, headers, file_contents, use_gzip)
    catch
        return HTTP.Response(404)
    end
end

function make_handler(app::DashApp; debug::Bool = false)
    index_string::String = index_page(app, debug = debug)
    
    return function (req::HTTP.Request)
        body::Union{Nothing, String} = nothing
        uri = HTTP.URI(req.target)

        # verify that the client accepts compression
        accepts_gz = occursin("gzip", HTTP.header(req, "Accept-Encoding"))
        # verify that the server was not launched with compress=false
        with_gzip = accepts_gz && app.config.compress

        headers = []
        
        ComponentPackages.@register_js_sources(uri.path, app.config.routes_pathname_prefix)
        if uri.path == "$(app.config.routes_pathname_prefix)"
            body = index_page(app, debug = debug)
        end
        if uri.path == "$(app.config.routes_pathname_prefix)_dash-layout"
            body = JSON2.write(app.layout)
            push!(headers, "Content-Type" => "application/json")
        end
        if uri.path == "$(app.config.routes_pathname_prefix)_dash-dependencies"
            body = dependencies_json(app)
            push!(headers, "Content-Type" => "application/json")
        end
        if startswith(uri.path, "$(app.config.routes_pathname_prefix)assets/")
            return process_assets(app, uri.path, with_gzip)
        end
        if uri.path == "$(app.config.routes_pathname_prefix)_dash-update-component" && req.method == "POST"            
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
        if !isnothing(body)
            return make_response(200, headers, body, with_gzip)
        end
        return HTTP.Response(404)
    end 
end
