function clone(url::String, source_path::String)
    println(stdout, "cloning $(url)...")
    mkpath(source_path)
    try
        return LibGit2.clone(url, source_path)
    catch err
        rm(source_path; force=true, recursive=true)
        err isa LibGit2.GitError || err isa InterruptException || rethrow()
        if err isa InterruptException
            error("git clone of `$url` interrupted")
        elseif (err.class == LibGit2.Error.Net && err.code == LibGit2.Error.EINVALIDSPEC) ||
           (err.class == LibGit2.Error.Repository && err.code == LibGit2.Error.ENOTFOUND)
                error("git repository not found at `$(url)`")
        else
            error("failed to clone from $(url), error: $err")
        end
    end
end

function get_object_branch(repo, rev)
    gitobject = nothing
    isbranch = false
    LibGit2.fetch(repo, refspecs = ["+refs/*:refs/remotes/cache/*"])
    try
        gitobject = LibGit2.GitObject(repo, "remotes/cache/heads/" * rev)
        isbranch = true
    catch err
        err isa LibGit2.GitError && err.code == LibGit2.Error.ENOTFOUND || rethrow()
    end
    if isnothing(gitobject)
        try
            gitobject = LibGit2.GitObject(repo, rev)
        catch err
            err isa LibGit2.GitError && err.code == LibGit2.Error.ENOTFOUND || rethrow()
            error("git object $(rev) could not be found")
        end
    end
    return gitobject, isbranch
end

function checkout!(repo::LibGit2.GitRepo, rev::String)
    gitobject, isbranch = get_object_branch(repo, rev)

    LibGit2.with(LibGit2.peel(LibGit2.GitTree, gitobject)) do git_tree
        @assert git_tree isa LibGit2.GitTree
        opts = LibGit2.CheckoutOptions(
            checkout_strategy = LibGit2.Consts.CHECKOUT_FORCE,
        )
        LibGit2.checkout_tree(repo, git_tree)
    end
end