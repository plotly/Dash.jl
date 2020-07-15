struct Resource       
    relative_package_path::Union{Nothing, Vector{String}}
    dev_package_path::Union{Nothing, Vector{String}}
    external_url::Union{Nothing, Vector{String}}
    type::Symbol 
    async::Symbol # :none, :eager, :lazy May be we should use enum
    function Resource(;relative_package_path, dev_package_path = nothing, external_url = nothing, type = :js, dynamic = nothing, async=nothing) 
        (!isnothing(dynamic) && !isnothing(async)) && throw(ArgumentError("Can't have both 'dynamic' and 'async'"))
        !in(type, [:js, :css]) &&  throw(ArgumentError("type must be `:js` or `:css`"))
        async_symbol = :none
        if !isnothing(dynamic)
            dynamic == true && (async_symbol = :lazy)
        elseif !isnothing(async) && async != :false
            async_symbol = async == :lazy ? :lazy : :eager
        end
        return new(_path_to_vector(relative_package_path), _path_to_vector(dev_package_path), _path_to_vector(external_url), type, async_symbol)
    end
end

_path_to_vector(s::Nothing) = nothing
_path_to_vector(s::String) = [s]
_path_to_vector(s::Vector{String}) = s

has_relative_path(r::Resource) = !isnothing(r.relative_package_path)
has_dev_path(r::Resource) = !isnothing(r.dev_package_path)
has_external_url(r::Resource) = !isnothing(r.external_url)

get_type(r::Resource) = r.type
get_external_url(r::Resource) = r.external_url
get_dev_path(r::Resource) = r.dev_package_path
get_relative_path(r::Resource) = r.relative_package_path

isdynamic(resource::Resource, eager_loading::Bool) = resource.async == :lazy || (resource.async == :eager && !eager_loading)

struct ResourcePkg
    namespace ::String
    path ::String
    resources ::Vector{Resource}    
    version ::String
    ResourcePkg(namespace, path, resources = Resource[]; version = "")  = new(namespace, path, resources, version)
end



struct ResourcesRegistry    
    dash_dependency ::NamedTuple{(:dev, :prod), Tuple{ResourcePkg,ResourcePkg}}
    dash_renderer ::ResourcePkg
    components ::Dict{String, ResourcePkg}
    ResourcesRegistry(;dash_dependency, dash_renderer) = new(dash_dependency,  dash_renderer, Dict{String, ResourcePkg}())
end

function register_package!(registry::ResourcesRegistry, pkg::ResourcePkg)
    registry.components[pkg.namespace] = pkg
end

get_dash_dependencies(registry::ResourcesRegistry, prop_check::Bool) = prop_check ?
                                                                    registry.dash_dependency[:dev] :
                                                                    registry.dash_dependency[:prod]

get_componens_pkgs(registry::ResourcesRegistry) = values(registry.components)
get_dash_renderer_pkg(registry::ResourcesRegistry) = registry.dash_renderer



const RESOURCE_PATH = realpath(joinpath(ROOT_PATH, "resources"))

const resources_registry = ResourcesRegistry(
    dash_dependency = (
        dev = ResourcePkg(
            "dash_renderer",
            RESOURCE_PATH, version = "1.5.0",
            [
                Resource(
                relative_package_path = "react@16.13.0.js",
                external_url = "https://unpkg.com/react@16.13.0/umd/react.development.js"
                ),
                Resource(
                    relative_package_path = "react-dom@16.13.0.js",
                    external_url = "https://unpkg.com/react-dom@16.13.0/umd/react-dom.development.js"
                ),
                Resource(
                    relative_package_path = "polyfill@7.8.7.min.js",
                    external_url = "https://unpkg.com/@babel/polyfill@7.8.7/dist/polyfill.min.js"
                ),
                Resource(
                    relative_package_path = "prop-types@15.7.2.js",
                    external_url = "https://unpkg.com/prop-types@15.7.2/prop-types.js",
                ),
            ]
        ),
        prod = ResourcePkg(
            "dash_renderer",
            RESOURCE_PATH, version = "1.2.2",
            [
                Resource(
                relative_package_path = "react@16.13.0.min.js",
                external_url = "https://unpkg.com/react@16.13.0/umd/react.production.min.js"
                ),
                Resource(
                    relative_package_path = "react-dom@16.13.0.min.js",
                    external_url = "https://unpkg.com/react-dom@16.13.0/umd/react-dom.production.min.js"
                ),
                Resource(
                    relative_package_path = "polyfill@7.8.7.min.js",
                    external_url = "https://unpkg.com/@babel/polyfill@7.8.7/dist/polyfill.min.js"
                ),
                Resource(
                    relative_package_path = "prop-types@15.7.2.min.js",
                    external_url = "https://unpkg.com/prop-types@15.7.2/prop-types.min.js"
                ),
            ]
        ) 
    ),
    dash_renderer = ResourcePkg(
        "dash_renderer",
        RESOURCE_PATH, version = "1.5.0",
        [
            Resource(
                relative_package_path = "dash_renderer.min.js",
                dev_package_path = "dash_renderer.dev.js",
                external_url = "https://unpkg.com/dash-renderer@1.5.0/dash_renderer/dash_renderer.min.js"                
            ),
            Resource(
                relative_package_path = "dash_renderer.min.js.map",
                dev_package_path = "dash_renderer.dev.js.map",                
                dynamic = true,                
            ),            
        ]
    )    
)

register_package(pkg::ResourcePkg) = register_package!(resources_registry, pkg)

main_registry() = resources_registry
