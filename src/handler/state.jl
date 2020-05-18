mutable struct StateCache
    resources::ApplicationResources
    index_string ::String
    dependencies_json ::String
    StateCache(app, registry) = new(_cache_tuple(app, registry)...)
end

function _dependencies_json(app::DashApp)
    id_prop_named(p::IdProp) = (id = p[1], property = p[2])
    result = map(values(app.callbacks)) do dep
        (inputs = id_prop_named.(dep.id.input),
        state = id_prop_named.(dep.id.state),
        output = output_string(dep.id)
        )
    end
    return JSON2.write(result)
end

function _cache_tuple(app::DashApp, registry::ResourcesRegistry)
    app_resources = ApplicationResources(app, registry)
    index_string::String = index_page(app, app_resources)
    dependencies_json = _dependencies_json(app)
    return (app_resources, index_string, dependencies_json)
end

struct HandlerState
    app::DashApp
    registry::ResourcesRegistry
    cache::StateCache
    HandlerState(app, registry = main_registry()) = new(app, registry, StateCache(app, registry))
end

get_cache(state::HandlerState) = state.cache

function rebuild_cache!(state::HandlerState)
    cache = get_cache(state) 
    (cache.resources, cache.index_string, cache.dependencies) = _cache_tuple(state.app, state.registry)
end
