function fix_import(src_file, dest_file)
    source = replace(String(read(src_file)),
        "using Dash"=>"using ..Dash"
        )

    source = replace(source, "function __init__()" => "function __dash_init__()")
    write(dest_file, source)
end 

function copy_components_sources(repo_path, package_name)
    package_path = joinpath(CORE_COMPONENTS_SRCS, package_name)
    package_src_path = joinpath(package_path, "src")
    package_deps_path = joinpath(package_path, "deps")

    main_file = package_name * ".jl"

    rm(package_path, force=true, recursive=true)

    mkpath(package_src_path)
    mkpath(package_deps_path)

    for file in readdir(joinpath(repo_path, "src"))
        if file == main_file
            fix_import(joinpath(repo_path, "src", file), joinpath(package_src_path, file))
            continue
        end
        if endswith(file, ".jl")
            cp(joinpath(repo_path, "src", file), joinpath(package_src_path, file), force=true)
        end
    end
    cp(joinpath(repo_path, "deps"), package_deps_path, force=true)
end