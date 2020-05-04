struct DevTools
    ui::Bool
    props_check::Bool
    serve_dev_bundles::Bool
    hot_reload::Bool
    hot_reload_interval::Float32
    hot_reload_watch_interval::Float32
    hot_reload_max_retry::Int
    silence_routes_logging::Bool
    prune_errors::Bool
    function DevTools(debug = false; ui = nothing,
            props_check = nothing,
            serve_dev_bundles = nothing,
            hot_reload = nothing,
            hot_reload_interval = nothing,
            hot_reload_watch_interval = nothing,
            hot_reload_max_retry = nothing,
            silence_routes_logging = nothing,
            prune_errors = nothing)

        @env_default!(ui, Bool, debug)
        @env_default!(props_check, Bool, debug)
        @env_default!(serve_dev_bundles, Bool, debug)
        @env_default!(hot_reload, Bool, debug)
        @env_default!(silence_routes_logging, Bool, debug)
        @env_default!(prune_errors, Bool, debug)

        @env_default!(hot_reload_interval, Float64, 3.)
        @env_default!(hot_reload_watch_interval, Float64, 0.5)
        @env_default!(hot_reload_max_retry, Int, 8)

        return new(
            ui,
            props_check,
            serve_dev_bundles,
            hot_reload,
            hot_reload_interval,
            hot_reload_watch_interval,
            hot_reload_max_retry,
            silence_routes_logging,
            prune_errors
        )
    end
end