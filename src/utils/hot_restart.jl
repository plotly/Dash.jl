function is_hot_restart_available()
    return !isinteractive() && !isempty(Base.PROGRAM_FILE) 
end
function hot_restart(func::Function; check_interval = 1., env_key = "IS_HOT_RELOADABLE", suppress_warn = false)
    if !is_hot_restart_available()
        error("hot restart is disabled for intereactive sessions")
    end
    app_path = abspath(Base.PROGRAM_FILE)
    if get(ENV, env_key, "false") == "true"
        (server, _) = func()
        files = parse_includes(app_path)
        poll_until_changed(files, interval = check_interval)
        close(server)
    else
        julia_str = joinpath(Sys.BINDIR, Base.julia_exename())
        ENV[env_key] = "true"
        try
            while true
                sym = gensym()
                task = @async Base.eval(Main,
                    :(module $(sym) include($app_path) end)
                )
                wait(task)
            end
        catch e
            if e isa InterruptException 
                println("finished")
                return
            else
                rethrow(e)
            end
        end
    end
end