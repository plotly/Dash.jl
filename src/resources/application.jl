abstract type AppResource end

struct AppRelativeResource <: AppResource
    namespace ::String
    relative_path ::String
    version ::String
    ts ::Int64
end
struct AppExternalResource <: AppResource
    url ::String
end
struct AppCustomResource <: AppResource
    params ::Dict{String, String}
end
struct AppAssetResource <: AppResource
    path ::String
    ts ::Int64
end

struct NamespaceFiles
    base_path ::String
    files ::Set{String}
    NamespaceFiles(base_path) = new(base_path, Set{String}())
end

struct ApplicationResources
    files ::Dict{String, NamespaceFiles}
    css ::Vector{AppResource}
    js ::Vector{AppResource}
    favicon ::Union{Nothing, String}
    ApplicationResources(files, css, js, favicon) = new(files, css, js, favicon)
end


function ApplicationResources(app::DashApp, registry::ResourcesRegistry)
    css = AppResource[]
    js = AppResource[]
    favicon::Union{Nothing, String} = nothing
    files = Dict{String, NamespaceFiles}()
    
    serve_locally = get_setting(app, :serve_locally)
    assets_external_path = get_setting(app, :assets_external_path)
    dev = get_devsetting(app, :serve_dev_bundles)
    eager_loading = get_setting(app, :eager_loading)
    
    append_pkg = function(pkg)
        append!(css,
            _convert_resource_pkg(pkg, :css, dev = dev, serve_locally = serve_locally, eager_loading = eager_loading)
        )
        append!(js,
            _convert_resource_pkg(pkg, :js, dev = dev, serve_locally = serve_locally, eager_loading = eager_loading)
        )
    end

    asset_resource = serve_locally || isnothing(assets_external_path)  ?
                     (url, modified) -> AppAssetResource(url, modified) :
                     (url, modified) -> AppExternalResource(assets_external_path*url)

    append_pkg(get_dash_dependencies(registry, get_devsetting(app, :props_check)))

    append!(css, 
        _convert_external.(get_setting(app, :external_stylesheets))
    )
    append!(js, 
        _convert_external.(get_setting(app, :external_scripts))
    )

    if get_setting(app, :include_assets_files)
        walk_assets(app) do type, url, path, modified
            if type == :js
                push!(js, asset_resource(url, modified))
            elseif type == :css
                push!(css, asset_resource(url, modified))
            elseif type == :favicon
                favicon = url
            end
        end
    end

    append_pkg.(get_componens_pkgs(registry))
    append_pkg(get_dash_renderer_pkg(registry))

    fill_files(files, get_dash_dependencies(registry, get_devsetting(app, :props_check)), dev = dev, serve_locally = serve_locally)
    fill_files.(Ref(files), get_componens_pkgs(registry), dev = dev, serve_locally = serve_locally)
    fill_files(files, get_dash_renderer_pkg(registry), dev = dev, serve_locally = serve_locally)
    ApplicationResources(files, css, js, favicon)
end


function fill_files(dest::Dict{String, NamespaceFiles}, pkg::ResourcePkg; dev, serve_locally)
    !serve_locally && return

    if !haskey(dest, pkg.namespace)
        dest[pkg.namespace] = NamespaceFiles(pkg.path)
    end
    namespace_files = get!(dest, pkg.namespace, NamespaceFiles(pkg.path))
        full_path = (p)->joinpath(pkg.path, lstrip(p, ['/','\\']))
    for resource in pkg.resources
        paths = dev && has_dev_path(resource) ? get_dev_path(resource) : get_relative_path(resource)
        for path in paths
            push!.(
                Ref(namespace_files.files),
                lstrip.(path, Ref(['/', '\\']))
            )
        end
    end
end

function walk_assets(callback, app::DashApp)
    assets_ignore = get_setting(app, :assets_ignore)
    assets_regex = Regex(assets_ignore)

    assets_filter = isempty(assets_ignore) ?
        (f) -> true :
        (f) -> !occursin(assets_regex, f)
        
    if app.config.include_assets_files && isdir(app.config.assets_folder)
        for (base, dirs, files) in walkdir(app.config.assets_folder)
            if !isempty(files)
                relative = ""
                if base != app.config.assets_folder
                    relative = join(
                            splitpath(
                                relpath(base, app.config.assets_folder)
                            ), "/"
                        ) * "/"
                end
                for file in Iterators.filter(assets_filter, files)
                    file_type::Symbol = endswith(file, ".js") ? :js :
                                (
                                    endswith(file, ".css") ? :css :
                                    (
                                        file == "favicon.ico" ? :favicon : :none
                                    )
                                )

                    if file_type != :none
                        full_path = joinpath(base, file)
                        callback(file_type,
                                relative*file,
                                full_path,
                                trunc(Int64, stat(full_path).mtime)
                                )
                    end
                end

            end


        end
    end
end

_convert_external(v::String) = AppExternalResource(v)
_convert_external(v::Dict{String, String}) = AppCustomResource(v)

function _convert_resource(resource::Resource; namespace, version, ts, dev, serve_locally)::Vector{AppResource}
    if !serve_locally && has_external_url(resource)
        return AppExternalResource.(get_external_url(resource))
    end
    relative_path = dev && has_dev_path(resource) ?
                    get_dev_path(resource) :
                    (has_relative_path(resource) ? get_relative_path(resource) : nothing)
    if !isnothing(relative_path)
        return AppRelativeResource.(namespace, relative_path, version, ts)
    end
    if serve_locally
        #TODO Warning
        #FIXME Why warning? It's strange logic in python§
        return AppResource[]
    end
    error("$(resource) does not have a relative_package_path, absolute_path, or an external_url.")
end

function _convert_resource_pkg(pkg::ResourcePkg, type::Symbol; dev, serve_locally, eager_loading)
    result = AppResource[]
    iterator = Iterators.filter(pkg.resources) do r
        get_type(r) == type && !isdynamic(r, eager_loading)
    end
    ts = ispath(pkg.path) ? trunc(Int64, stat(pkg.path).mtime) : 0
    for resource in iterator
        append!(
            result, 
            _convert_resource(
                    resource, 
                    namespace = pkg.namespace,
                    version = pkg.version,
                    ts = ts,
                    dev = dev, serve_locally = serve_locally
                )
            )
    end
    return result
end
