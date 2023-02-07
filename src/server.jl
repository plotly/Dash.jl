"""
    run_server(app::DashApp, host = HTTP.Sockets.localhost, port = 8050; debug::Bool = false)

Run Dash server

#Arguments
- `app` - Dash application
- `host` - host
- `port` - port
- `debug::Bool = false` - Enable/disable all the dev tools

#Examples
```jldoctest
julia> app = dash() do
    html_div() do
        html_h1("Test Dashboard")
    end
end
julia>
julia> run_server(handler,  HTTP.Sockets.localhost, 8050)
```

"""
function run_server(app::DashApp,
            host = dash_env("HOST", "127.0.0.1", prefix = ""),
            port = dash_env(Int64, "PORT", 8050, prefix = "");
            debug = nothing,
            dev_tools_ui = nothing,
            dev_tools_props_check = nothing,
            dev_tools_serve_dev_bundles = nothing,
            dev_tools_hot_reload = nothing,
            dev_tools_hot_reload_interval = nothing,
            dev_tools_hot_reload_watch_interval = nothing,
            dev_tools_hot_reload_max_retry = nothing,
            dev_tools_silence_routes_logging = nothing,
            dev_tools_prune_errors = nothing
            )
    @env_default!(debug, Bool, false)
    enable_dev_tools!(app,
        debug = debug,
        dev_tools_ui = dev_tools_ui,
        dev_tools_props_check = dev_tools_props_check,
        dev_tools_serve_dev_bundles = dev_tools_serve_dev_bundles,
        dev_tools_hot_reload = dev_tools_hot_reload,
        dev_tools_hot_reload_interval = dev_tools_hot_reload_interval,
        dev_tools_hot_reload_watch_interval = dev_tools_hot_reload_watch_interval,
        dev_tools_hot_reload_max_retry = dev_tools_hot_reload_max_retry,
        dev_tools_silence_routes_logging = dev_tools_silence_routes_logging,
        dev_tools_prune_errors = dev_tools_prune_errors
    )

    start_server = () -> begin
        handler = make_handler(app);
        server = Sockets.listen(get_inetaddr(host, port))
        task = @async HTTP.serve(handler, host, port; server = server)
        return (server, task)
    end

    if get_devsetting(app, :hot_reload) && !is_hot_restart_available()
        @warn "Hot reloading is disabled for interactive sessions. Please run your app using julia from the command line to take advantage of this feature."
    end

    if get_devsetting(app, :hot_reload) && is_hot_restart_available()
        hot_restart(start_server, check_interval = get_devsetting(app, :hot_reload_watch_interval))
    else
        (server, task) = start_server()
        try
            wait(task)
        catch e
            close(server)
            if e isa InterruptException
                println("finished")
                return
            else
                rethrow(e)
            end
        end
    end
end
get_inetaddr(host::String, port::Integer) = Sockets.InetAddr(parse(IPAddr, host), port)
get_inetaddr(host::IPAddr, port::Integer) = Sockets.InetAddr(host, port)