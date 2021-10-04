using YAML

load_meta(name) = YAML.load_file(
            joinpath(artifact"dash_resources", "$(name).yaml")
            )


deps_path(name) = joinpath(artifact"dash_resources", "$(name)_deps")

dash_dependency_resource(meta) = Resource(
        relative_package_path = meta["relative_package_path"],
        external_url = meta["external_url"]
    )

nothing_if_empty(v) = isempty(v) ? nothing : v

dash_module_resource(meta) = Resource(
        relative_package_path = nothing_if_empty(get(meta, "relative_package_path", "")),
        external_url = nothing_if_empty(get(meta, "external_url", "")),
        dev_package_path = nothing_if_empty(get(meta, "dev_package_path", "")),
        dynamic = get(meta, "dynamic", nothing),
        type = Symbol(meta["type"]),
        async = haskey(meta, "async") ? string(meta["async"]) : nothing
    )

dash_module_resource_pkg(meta; resource_path, version) = ResourcePkg(
    meta["namespace"],
    resource_path, version = version,
    dash_module_resource.(meta["resources"])
)

function setup_renderer_resources()
    renderer_meta = _metadata.dash_renderer
    renderer_resource_path = joinpath(artifact"dash_resources", "dash_renderer_deps")
    DashBase.main_registry().dash_dependency = (
        dev = ResourcePkg(
            "dash_renderer",
            renderer_resource_path, version = renderer_meta["version"],
            dash_dependency_resource.(renderer_meta["js_dist_dependencies"]["dev"])
        ),
        prod = ResourcePkg(
            "dash_renderer",
            renderer_resource_path, version = renderer_meta["version"],
            dash_dependency_resource.(renderer_meta["js_dist_dependencies"]["prod"])
        )
    )

    DashBase.main_registry().dash_renderer = dash_module_resource_pkg(
            renderer_meta["deps"][1],
            resource_path = renderer_resource_path,
            version = renderer_meta["version"]
            )
end

function load_all_metadata()
    dash_meta = load_meta("dash")
    renderer_meta = load_meta("dash_renderer")
    components = Dict{Symbol, Any}()
    for comp in dash_meta["embedded_components"]
        components[Symbol(comp)] = filter(v->v.first!="components", load_meta(comp))
    end
    return (
        dash = dash_meta,
        dash_renderer = renderer_meta,
        embedded_components = (;components...)
    )
end

function setup_dash_resources()
    meta = _metadata.dash
    path = deps_path("dash")
    version = meta["version"]
    for dep in meta["deps"]
        DashBase.register_package(
            dash_module_resource_pkg(
                dep,
                resource_path = path,
                version = version
            )
        )
    end
end