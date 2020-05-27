import LibGit2
const ROOT_PATH = abspath(joinpath(@__DIR__, ".."))
const CORE_COMPONENTS_PATH = joinpath(ROOT_PATH, "core_components")
const CORE_COMPONENTS_SRCS = joinpath(CORE_COMPONENTS_PATH, "sources")

(isdir(CORE_COMPONENTS_SRCS) && !isempty(readdir(CORE_COMPONENTS_SRCS))) && exit(0)

include(joinpath(CORE_COMPONENTS_PATH, "versions.jl"))

include("git.jl")
include("files.jl")


mktempdir() do temp_path
    for pkg_name in keys(COMPONENT_VERSIONS)
        pkg = COMPONENT_VERSIONS[pkg_name]
        pkg_string = string(pkg_name)
        clone_path = joinpath(temp_path, pkg_string)
        repo = clone(pkg.url, clone_path)
        checkout!(repo::LibGit2.GitRepo, pkg.rev)
        copy_components_sources(clone_path, pkg_string)
    end
end