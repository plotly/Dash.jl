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

function process_dependencies(request::HTTP.Request, state::HandlerState)
    return HTTP.Response(
        200,
        ["Content-Type", "application/json"],
        body = state.cache.dependencies_json
        )
end

function process_index(request::HTTP.Request, state::HandlerState)
    return HTTP.Response(
        200,
        ["Content-Type", "text/html"],
        body = state.cache.index_string
        )
end

function process_layout(request::HTTP.Request, state::HandlerState)
            body = 
    return HTTP.Response(
        200,
        ["Content-Type", "application/json"],
        body = JSON2.write(state.app.layout)
    )
end

function process_callback(request::HTTP.Request, state::HandlerState)
    body = String(request.body)
    app = state.app
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

function mime_by_path(path)
    endswith(path, ".js") && return "application/javascript"
    endswith(path, ".css") && return "application/css"
    endswith(path, ".map") && return "application/json"
    return nothing
end
function process_resource(request::HTTP.Request, state::HandlerState)
    # /_dash-component-suites{1}/namespace{2}/rest path{3}
    path::SubString = lstrip(HTTP.URI(request.target).path, '/')
    (_, namespace, path) = split(path, '/', limit = 3)
    (relative_path, is_fp) = parse_fingerprint_path(path)
    registered_files = state.cache.resources.files
    if !haskey(registered_files, namespace)
        #TODO Exception like in python
        return HTTP.Response(404)
    end
    namespace_files = registered_files[namespace]
    if !in(relative_path, namespace_files.files)
        #TODO Exception like in python
        return HTTP.Response(404)
    end

    filepath = joinpath(namespace_files.base_path, relative_path)

    try
        headers = Pair{String,String}[]
        file_contents = read(joinpath(namespace_files.base_path, relative_path))
        mimetype = mime_by_path(relative_path)
        !isnothing(mimetype) && push!(headers, "Content-Type" => mimetype)
        if is_fp 
            push!(headers, 
                "Cache-Control" => "public, max-age=31536000" # 1 year
            )
        else
            etag = bytes2hex(MD5.md5(file_contents))
            push!(headers, "ETag" => etag)
            request_etag = HTTP.header(request, "If-None-Match", "")
            request_etag == etag && return HTTP.Response(304)
        end
        return HTTP.Response(200, headers; body = file_contents)
        
    catch e
        !(e isa SystemError) && rethrow(e)
        #TODO print to log
        return HTTP.Response(404)
    end
end


function process_assets(request::HTTP.Request, state::HandlerState)
    app = state.app
    path = HTTP.URI(request.target).path
    assets_path = "$(get_setting(app, :routes_pathname_prefix))" * strip(get_setting(app, :assets_url_path), '/') * "/"
    filename = joinpath(app.config.assets_folder, replace(path, assets_path=>""))

    try
        file_contents = read(filename)
        return HTTP.Response(200, file_contents)
    catch
        return HTTP.Response(404)
    end
    
end

const dash_router = HTTP.Router()



function make_handler(app::DashApp; debug = nothing, ui = nothing,
            props_check = nothing,
            serve_dev_bundles = nothing,
            hot_reload = nothing,
            hot_reload_interval = nothing,
            hot_reload_watch_interval = nothing,
            hot_reload_max_retry = nothing,
            silence_routes_logging = nothing,
            prune_errors = nothing)

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
    app_resources = ApplicationResources(app, main_registry())

    index_string::String = index_page(app, app_resources)
    
    return function (req::HTTP.Request)
        body::Union{Nothing, String} = nothing
        uri = HTTP.URI(req.target)

        # verify that the client accepts compression
        accepts_gz = occursin("gzip", HTTP.header(req, "Accept-Encoding"))
        # verify that the server was not launched with compress=false
        with_gzip = accepts_gz && app.config.compress

        headers = []
        
        #ComponentPackages.@register_js_sources(uri.path, app.config.routes_pathname_prefix)
        if uri.path == "$(app.config.routes_pathname_prefix)"
            body = index_string
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