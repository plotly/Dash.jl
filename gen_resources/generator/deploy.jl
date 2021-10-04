function init_deploy_repo(deploy_repo, dest_dir)
    gh_auth = github_auth(;allow_anonymous=false)
    gh_username = gh_get_json(DEFAULT_API, "/user"; auth=gh_auth)["login"]
    try
        GitHub.repo(deploy_repo; auth=gh_auth)
    catch e
        error("Resources repo `$(deploy_repo)` don't exists.")
    end

    #Always do new clone
    if isdir(dest_dir)
        rm(dest_dir, force = true, recursive = true)
    end
    @info("Cloning resources repo from https://github.com/$(deploy_repo) into $(dest_dir)")
    with_gitcreds(gh_username, gh_auth.token) do creds
        LibGit2.clone("https://github.com/$(deploy_repo)", dest_dir; credentials=creds)
    end
end


function old_build_info(dest_dir)
    default_info = (dash_version = v"0.0.0", build = 0)
    meta_path = joinpath(resources_dir(dest_dir), "dash.yaml")
    !isfile(meta_path) && return default_info
    try
        meta = YAML.load_file(meta_path)
        v = VersionNumber(meta["version"])
        build_n = meta["build"]
        (dash_version = v, build = build_n)
    catch e
        @error "error while loading dash.yaml" e
        return default_info
    end
end

function make_new_info(dash_version, old_info)
    if old_info.dash_version > dash_version
        error("You try to generate resources for dash $(dash_version), but $(deploy_repo) alredy contains version $(old_info.dash_version)")
    end
    build_n = old_info.dash_version == dash_version ? old_info.build + 1 : 0
    return (dash_version = dash_version, build = build_n)
end
function cleanup_deploy(deploy_dir)
end
resources_dir(deploy_dir) = joinpath(deploy_dir, "resources")
function fill_deploy_resources(sources, deploy_dir, info)
    resources_path = resources_dir(deploy_dir)
    #cleanup resources
    rm(resources_path, force = true, recursive = true)

    mkdir(resources_path)
    cd(resources_path) do
        @info "creating dash meta..."
        dash_meta = OrderedDict(
            :version => info.dash_version,
            :build => info.build,
            :embedded_components => Symbol.(collect(keys(sources["components"])))
        )

        dash_deps = OrderedDict{Symbol, Any}()
        dash_deps_files = Vector{String}()

        for (name, props) in sources["components"]
            fill_components_deps!(dash_deps, dash_deps_files, props["module"])
        end
        dash_meta[:deps] = collect(values(dash_deps))

        YAML.write_file("dash.yaml", dash_meta)

        mkdir("dash_deps")
        copy_files(dash_module_dir(), dash_deps_files, "dash_deps")

        @info "creating dash-renderer meta..."
        module_src, meta, files = renderer_resources(
                sources["dash_renderer"]["module"]
            )
        resources_path = realpath(
            joinpath(
                module_src,
                get(sources["dash_renderer"], "resources_path", ".")
            )
        )
        YAML.write_file("dash_renderer.yaml", meta)

        @info "copying dash-renderer resource files..."
        mkdir("dash_renderer_deps")
        copy_files(resources_path, files, "dash_renderer_deps/")
        @info "dash-renderer done"

        @info "processing components modules..."
        for (name, props) in sources["components"]
            @info "processing $name meta..."
            meta = components_module_resources(
                    props["module"];
                    name = name,
                    prefix = props["prefix"],
                    metadata_file = props["metadata_file"],
                )
            YAML.write_file("$(name).yaml", meta)
        end
    end
end

deploy_version(info) = VersionNumber(
    info.dash_version.major,
    info.dash_version.minor,
    info.dash_version.patch,
    info.dash_version.prerelease,
    (info.build,)
)

deploy_tagname(info) = string("v", deploy_version(info))

tarball_name(info) = string(
    "DashCoreResources.v", info.dash_version, ".tar.gz"
)

function push_repo(repo_name, deploy_dir, tag)
    println("https://github.com/$(repo_name).git")
    gh_auth = github_auth(;allow_anonymous=false)
    gh_username = gh_get_json(DEFAULT_API, "/user"; auth=gh_auth)["login"]
    repo = LibGit2.GitRepo(deploy_dir)
    LibGit2.add!(repo, ".")
    commit = LibGit2.commit(repo, "dash core resources build $(tag)")
    with_gitcreds(gh_username, gh_auth.token) do creds
        refspecs = ["refs/heads/master"]
        # Fetch the remote repository, to have the relevant refspecs up to date.
        LibGit2.fetch(
            repo;
            refspecs=refspecs,
            credentials=creds,
        )
        LibGit2.branch!(repo, "master", string(LibGit2.GitHash(commit)); track="master")
        LibGit2.push(
            repo;
            refspecs=refspecs,
            remoteurl="https://github.com/$(repo_name).git",
            credentials=creds,
        )
    end
end
function upload_to_resleases(repo_name,  tag, tarball_path; attempts = 3)
    gh_auth = github_auth(;allow_anonymous=false)
    for attempt in 1:attempts
        try
            ghr() do ghr_path
                run(`$ghr_path -u $(dirname(repo_name)) -r $(basename(repo_name)) -t $(gh_auth.token) $(tag) $(tarball_path)`)
            end
            return
        catch
            @info("`ghr` upload step failed, beginning attempt #$(attempt)...")
        end
    end
    error("Unable to upload $(tarball_path) to GitHub repo $(repo_name) on tag $(tag)")
end