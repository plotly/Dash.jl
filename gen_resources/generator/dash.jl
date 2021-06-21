"""
    install_dash(url, tag)

Clone python dash into `dash` folder and install (reinstall) it to current python enviroment
"""
function install_dash(url, tag)
    Conda.pip_interop(true)
    Conda.pip("uninstall -y", "dash")
    rm("dash", force = true, recursive = true)
    mkdir("dash")
    repo = clone(url, "dash")

    obj = try
        LibGit2.GitObject(repo, tag)
    catch
        LibGit2.GitObject(repo, "origin/$tag")
    end
    source_hash = LibGit2.string(LibGit2.GitHash(obj))
    LibGit2.checkout!(repo, source_hash)

    cd("dash") do
        Conda.pip("install", "./")
    end
    dashmodule = pyimport("dash")
    return dashmodule.__version__
end

dash_version() = VersionNumber(pyimport("dash").__version__)

function convert_deps_part(relative, external)
    result = Dict{Symbol, String}[]
    for i in eachindex(relative)
        d = OrderedDict{Symbol, String}()
        d[:relative_package_path] = relative[i]
        if !isnothing(external)
            d[:external_url] = external[i]
        end
        push!(result, d)
    end
    return result
end
function convert_deps(pyresources)
    relative_paths = pyresources["relative_package_path"]
    external_urls = get(pyresources, "external_url", nothing)
    result = OrderedDict{Symbol, Any}()
    result[:namespace] = pyresources["namespace"]
    if haskey(relative_paths, "prod")
        result[:prod] = convert_deps_part(
            relative_paths["prod"],
            isnothing(external_urls) ? nothing : external_urls["prod"]
            )
    end
    if haskey(relative_paths, "dev")
        result[:dev] = convert_deps_part(
            relative_paths["dev"],
            isnothing(external_urls) ? nothing : external_urls["dev"]
            )
    end
    return result
end

function _process_dist_part!(dict, resource, type)
    ns_symbol = Symbol(resource["namespace"])
    if !haskey(dict, ns_symbol)
        dict[ns_symbol] = OrderedDict(
            :namespace => resource["namespace"],
            :resources => Dict[]
        )
    end
    data = filter(v->v.first != "namespace", resource)
    data[:type] = type
    push!(
        dict[ns_symbol][:resources], data
        )
end
function convert_resources(js_dist, css_dist)
    result = OrderedDict{Symbol, Any}()
    _process_dist_part!.(Ref(result), js_dist, :js)
    _process_dist_part!.(Ref(result), css_dist, :css)
    return collect(values(result))
end

function deps_files(pyresources)
    relative_paths = pyresources["relative_package_path"]
    result = String[]
    if haskey(relative_paths, "prod")
        append!(result, relative_paths["prod"])
    end
    if haskey(relative_paths, "dev")
        append!(result, relative_paths["dev"])
    end
    return result
end

function resources_files(pyresources)
    result = String[]
    for res in pyresources
        if haskey(res, "relative_package_path")
            push!(result, res["relative_package_path"])
        end
        if haskey(res, "dev_package_path")
            push!(result, res["dev_package_path"])
        end
    end
    return result
end

function copy_files(resource_dir, files, dest_dir)
    for f in files
        full_path = joinpath(resource_dir, f)
        if isfile(full_path)
            cp(full_path, joinpath(dest_dir, f); force = true)
        else
            @warn "File $f don't exists in $resource_dir, skipped"
        end
    end
end

function renderer_resources(module_name)
    m = pyimport(module_name)

    meta =  OrderedDict(
        :version => m.__version__,
        :js_dist_dependencies =>  convert_deps(m._js_dist_dependencies[1]),
        :deps => convert_resources(m._js_dist, hasproperty(m, :_css_dist) ? m._css_dist : [])
    )
    files = vcat(deps_files(m._js_dist_dependencies[1]), resources_files(m._js_dist))

    return (dirname(m.__file__), meta, files)
end

function components_module_resources(module_name; name, prefix, metadata_file)
    m = pyimport(module_name)
    moduledir = dirname(m.__file__)
    metafile = joinpath(moduledir, metadata_file)
    if !isfile(metafile)
        error("meta file $(metadata_file) don't exists for module $(name)")
    end
    components = process_components_meta(metafile)
    js_dist = hasproperty(m, :_js_dist) ? m._js_dist : []
    css_dist = hasproperty(m, :_css_dist) ? m._css_dist : []
    meta = OrderedDict(
        :version => m.__version__,
        :name => name,
        :deps => convert_resources(js_dist, css_dist),
        :prefix => prefix,
        :components => components
    )
    files = vcat(resources_files(js_dist), resources_files(css_dist))

    return (dirname(m.__file__), meta, files)
end