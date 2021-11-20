using Test
using Dash
using Dash: HandlerState, main_registry, start_reload_poll, enable_dev_tools!
import HTTP
import JSON3
@testset "reload state" begin
    rm("assets/test2.png", force = true)
    app = dash()
    enable_dev_tools!(app, dev_tools_hot_reload_watch_interval = 1.)
    app.layout = html_div()
    state = HandlerState(app, main_registry())
    start_reload_poll(state)
    initial_hash = state.reload.hash
    sleep(1)
    @test length(state.reload.changed_assets) == 0
    write("assets/test2.png", "")
    sleep(2)
    @test state.reload.hash != initial_hash
    @test length(state.reload.changed_assets) == 1
    @test length(state.reload.changed_assets) == 1
    @test state.reload.changed_assets[1].url == "/assets/test2.png"
    rm("assets/test2.png", force = true)

end
@testset "reload handler" begin
    rm("assets/test2.css", force = true)
    app = dash()
    enable_dev_tools!(app, dev_tools_hot_reload = true, dev_tools_hot_reload_watch_interval = 1.)
    app.layout = html_div()
    handler = make_handler(app)
    write("assets/test2.css", "")
    sleep(2)
    response = HTTP.handle(handler, HTTP.Request("GET", "/_reload-hash"))
    data = JSON3.read(response.body)
    @test length(data.files) == 1
    @test data.files[1].url == "/assets/test2.css"
    @test data.files[1].is_css == true
    rm("assets/test2.css", force = true)
end