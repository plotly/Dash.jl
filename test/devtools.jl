using Test
using Dash
using Dash:DevTools
@testset "DevTools creation" begin
    @test true
    tools = DevTools()
    @test tools.ui == false
    @test tools.props_check == false
    @test tools.serve_dev_bundles == false
    @test tools.hot_reload == false
    @test tools.silence_routes_logging == false
    @test tools.prune_errors == false

    @test tools.hot_reload_interval ≈ 3.
    @test tools.hot_reload_watch_interval ≈ 0.5
    @test tools.hot_reload_max_retry ≈ 8

    tools = DevTools(false)
    @test tools.ui == false
    @test tools.props_check == false
    @test tools.serve_dev_bundles == false
    @test tools.hot_reload == false
    @test tools.silence_routes_logging == false
    @test tools.prune_errors == false
    
    @test tools.hot_reload_interval ≈ 3.
    @test tools.hot_reload_watch_interval ≈ 0.5
    @test tools.hot_reload_max_retry ≈ 8

    tools = DevTools(true)
    @test tools.ui == true
    @test tools.props_check == true
    @test tools.serve_dev_bundles == true
    @test tools.hot_reload == true
    @test tools.silence_routes_logging == true
    @test tools.prune_errors == true
    
    @test tools.hot_reload_interval ≈ 3.
    @test tools.hot_reload_watch_interval ≈ 0.5
    @test tools.hot_reload_max_retry ≈ 8

    tools = DevTools(true,
        props_check = false,
        serve_dev_bundles = true,
        hot_reload = false,
        silence_routes_logging = true,
        prune_errors = false,
        hot_reload_interval = 2.2,
        hot_reload_watch_interval = 0.1,
        hot_reload_max_retry = 2
    )
    @test tools.ui == true
    @test tools.props_check == false
    @test tools.serve_dev_bundles == true
    @test tools.hot_reload == false
    @test tools.silence_routes_logging == true
    @test tools.prune_errors == false
    
    @test tools.hot_reload_interval ≈ 2.2
    @test tools.hot_reload_watch_interval ≈ 0.1
    @test tools.hot_reload_max_retry ≈ 2
end

@testset "DevTools end" begin
        UI = false
        ENV["DASH_UI"] = "False"
        ENV["DASH_PROPS_CHECK"] = "False"
        ENV["DASH_SERVE_DEV_BUNDLES"] = "False"
        ENV["DASH_HOT_RELOAD"] = "False"
        ENV["DASH_SILENCE_ROUTES_LOGGING"] = "false"
        ENV["DASH_PRUNE_ERRORS"] = "0"
        ENV["DASH_HOT_RELOAD_INTERVAL"] = "2.8"
        ENV["DASH_HOT_RELOAD_WATCH_INTERVAL"] = "0.34"
        ENV["DASH_HOT_RELOAD_MAX_RETRY"] = "7"
        tools = DevTools(true)

        @test tools.ui == false
        @test tools.props_check == false
        @test tools.serve_dev_bundles == false
        @test tools.hot_reload == false
        @test tools.silence_routes_logging == false
        @test tools.prune_errors == false
        
        @test tools.hot_reload_interval ≈ 2.8
        @test tools.hot_reload_watch_interval ≈ 0.34
        @test tools.hot_reload_max_retry ≈ 7

        tools = DevTools(true, hot_reload_interval = 1.6)
        @test tools.hot_reload_interval ≈ 1.6

        delete!(ENV, "DASH_UI")
        delete!(ENV, "DASH_PROPS_CHECK")
        delete!(ENV, "DASH_SERVE_DEV_BUNDLES")
        delete!(ENV, "DASH_HOT_RELOAD")
        delete!(ENV, "DASH_SILENCE_ROUTES_LOGGING")
        delete!(ENV, "DASH_PRUNE_ERRORS")
        delete!(ENV, "DASH_HOT_RELOAD_INTERVAL")
        delete!(ENV, "DASH_HOT_RELOAD_WATCH_INTERVAL")
        delete!(ENV, "DASH_HOT_RELOAD_MAX_RETRY")
end
