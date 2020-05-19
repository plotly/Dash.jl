function is_hot_restart_available()
    return !isinteractive() && !isempty(Base.PROGRAM_FILE) 
end
function hot_restart(func::Function; check_interval = 1., env_key = "IS_HOT_RELOADABLE", suppress_warn = false)
    if !is_hot_restart_available()
        !suppress_warn && @warn "hot restart is disabled for intereactive sessions"
        return func()
    end
    app_path = abspath(Base.PROGRAM_FILE)
    if get(ENV, env_key, "false") == "true"
        @async func()
        files = parse_includes(app_path)
        poll_until_changed(files, interval = check_interval)
        exit(3)
    else
        julia_str = joinpath(Sys.BINDIR, Base.julia_exename())
        new_env = deepcopy(ENV)
        new_env[env_key] = "true"
        cmd = Cmd(`$(julia_str) $(app_path)`, env = new_env, ignorestatus = true, windows_hide = true)
        subp_ref = Ref{Base.Process}()
        atexit() do
            if isdefined(subp_ref, 1) && process_running(subp_ref[])
                kill(subp_ref[])
            end
        end
        while true
            subp_ref[] = run(pipeline(cmd, stdout = stdout, stderr = stderr), wait = false)
            wait(subp_ref[])
            subp_ref[].exitcode != 3 && break
        end
    end
end