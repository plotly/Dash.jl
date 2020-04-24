struct Resource       
    relative_package_path::Union{String, Vector{String}}
    dev_package_path::Union{Nothing, String, Vector{String}}
    external_url::Union{Nothing, String, Vector{String}}
    type::Symbol
    dynamic::Union{Bool, Nothing}
    async::Union{Symbol, Nothing}    
    Resource(;relative_package_path, dev_package_path = nothing, external_url = nothing, type = :js, dynamic = nothing, async=nothing) =
        new(relative_package_path, dev_package_path, external_url, type, dynamic, async)
end

struct ResourcePkg
    namespace ::String
    path ::String
    resources ::Vector{Resource}    
    ResourcePkg(namespace, path, resources = Resource[])  = new(namespace, path, resources)
end

struct ResourcesRegistry    
    dash_dependency ::NamedTuple{(:dev, :prod), Tuple{ResourcePkg,ResourcePkg}}
    dash_renderer ::ResourcePkg
    components ::Dict{String, ResourcePkg}
    ResourcesRegistry(;dash_dependency, dash_renderer) = new(dash_dependency,  dash_renderer, Dict{String, ResourcePkg}())
end

function register_package!(registry::ResourcesRegistry, pkg::ResourcePkg)
    registry[pkg.namespace] = pkg
end

const RESOURCE_PATH = realpath(joinpath(@__DIR__, "..", "resources"))

const resources_registry = ResourcesRegistry(
    dash_dependency = (
        dev = ResourcePkg(
            "dash_renderer",
            RESOURCE_PATH,
            [
                Resource(
                relative_package_path = "react@16.8.6/umd/react.production.min.js",
                external_url = "https://unpkg.com/react@16.8.6/umd/react.production.min.js",        
                ),
                Resource(
                    relative_package_path = "react-dom@16.8.6/dist/react-dom.production.min.js",
                    external_url = "https://unpkg.com/react-dom@16.8.6/dist/react-dom.production.min.js"        
                ),
                Resource(
                    relative_package_path = "polyfill@7.7.0/dist/polyfill.min.js",
                    external_url = "https://unpkg.com/@babel/polyfill@7.7.0/dist/polyfill.min.js"        
                ),
                Resource(
                    relative_package_path = "prop-types@15.7.2/prop-types/prop-types.js",
                    external_url = "https://unpkg.com/prop-types@15.7.2/prop-types/prop-types.js",                
                ),
            ]
        ),
        prod = ResourcePkg(
            "dash_renderer",
            RESOURCE_PATH,
            [
                Resource(
                relative_package_path = "react@16.8.6/umd/react.production.min.js",
                external_url = "https://unpkg.com/react@16.8.6/umd/react.production.min.js",        
                ),
                Resource(
                    relative_package_path = "react-dom@16.8.6/dist/react-dom.production.min.js",
                    external_url = "https://unpkg.com/react-dom@16.8.6/dist/react-dom.production.min.js"        
                ),
                Resource(
                    relative_package_path = "polyfill@7.7.0/dist/polyfill.min.js",
                    external_url = "https://unpkg.com/@babel/polyfill@7.7.0/dist/polyfill.min.js"        
                ),
                Resource(
                    relative_package_path = "prop-types@15.7.2/prop-types/prop-types.min.js",
                    external_url = "https://unpkg.com/prop-types@15.7.2/prop-types/prop-types.min.js",                
                ),
            ]
        ) 
    ),
    dash_renderer = ResourcePkg(
        "dash_renderer",
        RESOURCE_PATH,
        [
            Resource(
                relative_package_path = "dash-renderer@1.2.2/dash-renderer/dash_renderer.min.js",
                dev_package_path = "dash-renderer@1.2.2/dash-renderer/dash_renderer.dev.js",
                external_url = "https://unpkg.com/dash-renderer@1.2.2/dash-renderer/dash_renderer.min.js"                
            ),
            Resource(
                relative_package_path = "dash-renderer@1.2.2/dash-renderer/dash_renderer.min.js.map",
                dev_package_path = "dash-renderer@1.2.2/dash-renderer/dash_renderer.dev.js.map",                
                dynamic = true,                
            ),            
        ]
    )    
)

register_package(pkg::ResourcePkg) = register_package!(resources_registry, pkg)