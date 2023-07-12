include("gitutils.jl")
include("github.jl")
include("dash.jl")
include("components.jl")
include("deploy.jl")

const HELP = """
Usage: generate.jl [--deploy] [--help]

Options:

--deploy   Deploy resources to repo specified in `Sources.toml`
--help     Print out this message.
"""


function generate(ARGS, sources, build_dir, artifact_file)
    if "--help" in ARGS
        println(HELP)
        return nothing
    end

    is_deploy =  "--deploy" in ARGS

    deploy_dir = joinpath(build_dir, "deploy")

    rm(build_dir, force = true, recursive = true)
    mkdir(build_dir)

    cd(build_dir)
    @info "cloning dash..."
    v = install_dash(sources["dash"]["url"], sources["dash"]["tag"])
    dash_version = VersionNumber(v)
    @info "dash succefully installed" dash_version

    deploy_repo = sources["deploy"]["repo"]

    init_deploy_repo(deploy_repo, deploy_dir)

    old_info = old_build_info(deploy_dir)
    new_info = make_new_info(dash_version, old_info)
    @info "filling resources data..."
    fill_deploy_resources(sources, deploy_dir, new_info)
    @info "resources data filled"

    artifact_hash = create_artifact() do dir
        res_dir = resources_dir(deploy_dir)
        for name in readdir(res_dir)
            cp(
                joinpath(res_dir, name),
                joinpath(dir, name)
            )
        end
    end
    @info "artifact created" artifact_hash
    if is_deploy
        @info "pushing repo to https://github.com/$(deploy_repo)..."
        push_repo(deploy_repo, deploy_dir, deploy_tagname(new_info))
        @info "repo pushed"

        @info "creating tagball..."
        tarball_hash = archive_artifact(artifact_hash, joinpath(build_dir, tarball_name(new_info)))
        @info "tagball created" tarball_hash

        @info "binding artifact..."
        download_info = (
            "https://github.com/$(deploy_repo)/releases/download/$(deploy_tagname(new_info))/$(tarball_name(new_info))",
            tarball_hash
        )
        bind_artifact!(artifact_file, "dash_resources",  artifact_hash, force = true, download_info = [download_info])
        @info "artifact binding succefully to" artifact_file

        cd(deploy_dir) do
            upload_to_releases(deploy_repo,
                deploy_tagname(new_info),
                realpath(joinpath(build_dir, tarball_name(new_info)))
            )
        end
    else
        unbind_artifact!(artifact_file, "dash_resources")
        bind_artifact!(artifact_file, "dash_resources",  artifact_hash, force = true, download_info = nothing)
        @info "artifact binding succefully to" artifact_file
    end
    @info "resource generation done!"

end
