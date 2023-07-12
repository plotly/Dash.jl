using ProgressMeter
import LibGit2

struct GitTransferProgress
    total_objects::Cuint
    indexed_objects::Cuint
    received_objects::Cuint
    local_objects::Cuint
    total_deltas::Cuint
    indexed_deltas::Cuint
    received_bytes::Csize_t
end

function transfer_progress(progress::Ptr{GitTransferProgress}, p::Any)
    progress = unsafe_load(progress)
    p.n = progress.total_objects
    if progress.total_deltas != 0
        p.desc = "Resolving Deltas: "
        p.n = progress.total_deltas
        update!(p, Int(max(1, progress.indexed_deltas)))
    else
        update!(p, Int(max(1, progress.received_objects)))
    end
    return Cint(0)
end

"""
    clone(url::String, source_path::String)
Clone a git repository hosted at `url` into `source_path`, with a progress bar
displayed to stdout.
"""
function clone(url::String, source_path::String)
    # Clone with a progress bar
    p = Progress(0, 1, "Cloning: ")
    GC.@preserve p begin
        callbacks = LibGit2.RemoteCallbacks(
            transfer_progress=@cfunction(                transfer_progress,
                Cint,
                (Ptr{GitTransferProgress}, Any)
            ),
            payload = p
        )
        fetch_opts = LibGit2.FetchOptions(callbacks=callbacks)
        clone_opts = LibGit2.CloneOptions(fetch_opts=fetch_opts, bare = Cint(false))
        return LibGit2.clone(url, source_path, clone_opts)
    end
end

"""
    with_gitcreds(f, username::AbstractString, password::AbstractString)

Calls `f` with an `LibGit2.UserPasswordCredential` object as an argument, constructed from
the `username` and `password` values. `with_gitcreds` ensures that the credentials object
gets properly shredded after it's no longer necessary. E.g.:

```julia
with_gitcreds(user, token) do creds
    LibGit2.clone("https://github.com/foo/bar.git", "bar"; credentials=creds)
end
````
"""
function with_gitcreds(f, username::AbstractString, password::AbstractString)
    creds = LibGit2.UserPasswordCredential(deepcopy(username), deepcopy(password))
    try
        f(creds)
    finally
        Base.shred!(creds)
    end
end
