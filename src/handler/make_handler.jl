include("processors/assets.jl")
include("processors/callback.jl")
include("processors/dependecies.jl")
include("processors/index.jl")
include("processors/layout.jl")
include("processors/reload_hash.jl")
include("processors/resource.jl")

function start_reload_poll(state::HandlerState)
    folders = Set{String}()
    push!(folders, get_assets_path(state.app))
    push!(folders, state.registry.dash_renderer.path)
    for pkg in values(state.registry.components)
        push!(folders, pkg.path)
    end
    state.reload.task = @async poll_folders(folders; interval = get_devsetting(state.app, :hot_reload_watch_interval)) do file, ts, deleted
        state.reload.hard = true
        state.reload.hash = generate_hash()
        assets_path = get_assets_path(state.app)
        if startswith(file, assets_path)
            state.cache.need_recache = true
            rel_path = lstrip(
                    replace(relpath(file, assets_path), '\\'=>'/'),
                    '/'
                )
            push!(state.reload.changed_assets, 
                ChangedAsset(
                    asset_path(state.app, rel_path), 
                    trunc(Int, ts),
                    endswith(file, "css")
                    )
            )
        end

    end
end

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
    add_route!(process_reload_hash, router, "$(prefix)_reload-hash")
    add_route!(process_resource, router, "$(prefix)_dash-component-suites/<namespace>/<path>")
    add_route!(process_assets, router, "$(prefix)$(assets_url_path)/<file_path>")
    add_route!(process_callback, router, "POST", "$(prefix)_dash-update-component")
    add_route!(process_index, router, "$prefix/*")
    add_route!(process_index, router, "$prefix")

    handler = state_handler(router, state)
    get_setting(app, :compress) && (handler = compress_handler(handler))

    compile_request = HTTP.Request("GET", prefix)
    HTTP.setheader(compile_request, "Accept-Encoding" => "gzip")
    HTTP.handle(handler, compile_request) #For handler precompilation

    get_devsetting(app, :hot_reload) && start_reload_poll(state)

    return handler
end

function make_handler(app::DashApp)
    return make_handler(app, main_registry(), check_layout = true)
end
