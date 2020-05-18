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

layout_data(layout::Component) = layout
layout_data(layout::Function) = layout()
function process_layout(request::HTTP.Request, state::HandlerState)
            body = 
    return HTTP.Response(
        200,
        ["Content-Type", "application/json"],
        body = JSON2.write(layout_data(state.app.layout))
    )
end

function _process_callback(app::DashApp, body::String)
    params = JSON2.read(body)
    output = Symbol(params[:output])
    if !haskey(app.callbacks, output)
        return []
    end
    convert_values(inputs) = map(inputs) do x
        return get(x, :value, nothing)        
    end 
    args = []
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

function process_callback(request::HTTP.Request, state::HandlerState)
        try
            return HTTP.Response(200, ["Content-Type" => "application/json"],
                body = JSON2.write(
                    _process_callback(state.app, String(request.body))
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


function mime_by_path(path)
    endswith(path, ".js") && return "application/javascript"
    endswith(path, ".css") && return "text/css"
    endswith(path, ".map") && return "application/json"
    return nothing
end
function process_resource(request::HTTP.Request, state::HandlerState; namespace::AbstractString, path::AbstractString)
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


function process_assets(request::HTTP.Request, state::HandlerState; file_path::AbstractString)
    app = state.app
    filename = joinpath(get_assets_path(app), file_path)

    try
        headers = Pair{String,String}[]
        mimetype = mime_by_path(filename)
        !isnothing(mimetype) && push!(headers, "Content-Type" => mimetype)
        file_contents = read(filename)
        return HTTP.Response(200, headers;body = file_contents)
    catch
        return HTTP.Response(404)
    end
    
end

const dash_router = HTTP.Router()

validate_layout(layout::Component) = validate(layout)

validate_layout(layout::Function) = validate_layout(layout())

validate_layout(layout) = error("The layout must be a component, tree of components, or a function which returns a component.")
#For test purposes, with the ability to pass a custom registry
function make_handler(app::DashApp, registry::ResourcesRegistry; check_layout = false)
            

    state = HandlerState(app, registry)
    prefix = get_setting(app, :routes_pathname_prefix)
    assets_url_path = get_setting(app, :assets_url_path)
    check_layout && validate_layout(get_layout(app))
    
    router = Router()
    add_route!(process_layout, router, "$(prefix)_dash-layout")
    add_route!(process_dependencies, router, "$(prefix)_dash-dependencies")
    add_route!(process_resource, router, "$(prefix)_dash-component-suites/<namespace>/<path>")
    add_route!(process_assets, router, "$(prefix)$(assets_url_path)/<file_path>")
    add_route!(process_callback, router, "POST", "$(prefix)_dash-update-component")
    add_route!(process_index, router, "$prefix/*")
    add_route!(process_index, router, "$prefix")

    handler = state_handler(router, state)
    get_setting(app, :compress) && (handler = compress_handler(handler))

    compile_request = HTTP.Request("GET", "/test_big")
    HTTP.setheader(compile_request, "Accept-Encoding" => "gzip")
    HTTP.handle(handler, compile_request) #For handler precompilation
    return handler
end

function make_handler(app::DashApp)
    return make_handler(app, main_registry(), check_layout = true)
end
