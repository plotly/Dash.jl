using Test
using HTTP
using Dash
using Dash: make_handler, compress_handler, process_resource, state_handler, HandlerState,
            process_resource, Route, Router, add_route!, make_handler
using Dash.HttpHelpers: StaticRoute, DynamicRoute, try_handle, RouteHandler, _make_route
using CodecZlib
using MD5

struct TestState
    setting::Bool
end
function path_request(path, method = "GET")
    request = HTTP.Request(method, path)
    r_path = HTTP.URI(request.target).path
    return (r_path, request)
end
@testset "route" begin
    route = DynamicRoute("/ddd/*/fff/*")
    @test route.static_segments == ((1, "ddd"), (3, "fff"))
    @test isempty(route.variables)

    route = DynamicRoute("/ddd/<var1>/fff/<var2>")
    @test route.static_segments == ((1,"ddd"), (3, "fff"))
    route.variables.var1 == 2
    route.variables.var2 == 4

    route = _make_route("/fff/sss/ggg/vvvv")
    @test route isa StaticRoute
    @test route.url == "/fff/sss/ggg/vvvv"

    route = _make_route("/fff/sss/<var1>/vvvv")
    @test route isa DynamicRoute

    route = _make_route("/test_req/test1")
    handler = (req) -> HTTP.Response(200)
    route_handler = RouteHandler(route, handler)
    res = try_handle(route_handler, path_request("/test_req/test2")...)
    @test isnothing(res)

    res = try_handle(route_handler, path_request("/test_req/test1")...)
    @test !isnothing(res)
    @test res.status == 200


    route = _make_route("/test_req/<var1>/test1")
    handler = (req;kwargs...) ->
        begin
            tmp = String[]
            for (k,v) in kwargs
                @test v isa SubString
                push!(tmp, string(k, "->",v))
            end
            HTTP.Response(200, join(tmp, ","))
        end
    route_handler = RouteHandler(route, handler)
    res = try_handle(route_handler, path_request("/test_req/asdasd/test2")...)
    @test isnothing(res)
    res = try_handle(route_handler, path_request("/test_req/asdasd/test1")...)
    @test res.status == 200
    @test String(res.body) == "var1->asdasd"
    res = try_handle(route_handler, path_request("/test_req/asdasd/test1/")...)
    @test res.status == 200
    @test String(res.body) == "var1->asdasd"

    route = _make_route("/test_req/*/test1")
    route_handler = RouteHandler(route, handler)
    res = try_handle(route_handler, path_request("/test_req/asdasd/test2")...)
    @test isnothing(res)
    res = try_handle(route_handler, path_request("/test_req/asdasd/test1")...)
    @test res.status == 200
    @test String(res.body) == ""

    route = _make_route("/test_req/*/test1/<var1>")
    route_handler = RouteHandler(route, handler)
    res = try_handle(route_handler, path_request("/test_req/asdasd/test1")...)
    @test isnothing(res)
    res = try_handle(route_handler, path_request("/test_req/asdasd/test1/ddd")...)
    @test res.status == 200
    @test String(res.body) == "var1->ddd"

    route = _make_route("/test_req/<var2>/test1/<var1>")
    route_handler = RouteHandler(route, handler)
    res = try_handle(route_handler, path_request("/test_req/asdasd/test1")...)
    @test isnothing(res)
    res = try_handle(route_handler, path_request("/test_req/as/test1/ddd")...)
    @test res.status == 200
    @test String(res.body) == "var1->ddd,var2->as"

    route = Route("GET", "/*") do req
        return HTTP.Response(200)
    end

    res = try_handle(route, path_request("/test_req")...)
    @test res.status == 200

    res = try_handle(route, path_request("/test_req",  "POST")...)
    @test isnothing(res)
end

@testset "router" begin
    router = Router()
    add_route!(router, "/") do req
        HTTP.Response(200, "index")
    end
    add_route!(router, "POST", "/test_post") do req
        HTTP.Response(200, "test_post")
    end

    handler1 = (req;var1) -> HTTP.Response(200, "var1=$var1")
    add_route!(handler1, router, "/var/<var1>/")

    add_route!((req;var1, var2) -> HTTP.Response(200, "var1=$var1,var2=$var2"),
        router, "/var/<var1>/<var2>/")

    res = Dash.HttpHelpers.handle(router, HTTP.Request("GET",""))
    @test res.status == 200
    @test String(res.body) == "index"

    res = Dash.HttpHelpers.handle(router, HTTP.Request("GET","/"))
    @test res.status == 200
    @test String(res.body) == "index"

    res = Dash.HttpHelpers.handle(router, HTTP.Request("GET","/test_post"))
    @test res.status == 404

    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/test_post"))
    @test res.status == 200
    @test String(res.body) == "test_post"

    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/var/"))
    @test res.status == 404

    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/var/ass"))
    @test res.status == 200
    @test String(res.body) == "var1=ass"
    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/var/ass/"))
    @test res.status == 200
    @test String(res.body) == "var1=ass"

    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/var/ass/fff"))
    @test res.status == 200
    @test String(res.body) == "var1=ass,var2=fff"
    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/var/ass/fff/"))
    @test res.status == 200
    @test String(res.body) == "var1=ass,var2=fff"
    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/var/ass/fff/dd"))
    @test res.status == 404

    add_route!((req, param;var1) -> HTTP.Response(200, "$param, var1=$var1"),
        router, "POST", "/<var1>")

    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/test_post"))
    @test res.status == 200
    @test String(res.body) == "test_post"

    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/test"), "aaa")
    @test res.status == 200
    @test String(res.body) == "aaa, var1=test"

    res = Dash.HttpHelpers.handle(router, HTTP.Request("POST","/test/renderer/r.js"), "aaa")
    @test res.status == 200
    @test String(res.body) == "aaa, var1=test/renderer/r.js"

end

@testset "base_handler" begin
    function structsequal(a::T, b::T)::Bool where T
        for name in propertynames(a)
            if getfield(a, name) != getfield(b, name)
                return false
            end
        end
        return true
    end

    base_handler = function(request, state)
        @test request.target == "/test_path"
        @test state isa TestState
        @test state.setting
        return HTTP.Response(200, "test1")
    end

    state = TestState(true)
    test_handler = state_handler(base_handler, state)
    test_request = HTTP.Request("GET", "/test_path")
    res = Dash.HttpHelpers.handle(test_handler, test_request)
     @test structsequal(res, test_handler(test_request))        #RequestHandlerFunction must be directly callable since HTTP.jl will use it
    @test res.status == 200
    @test String(res.body) == "test1"
    @test startswith(HTTP.header(res, "Content-Type", ""), "text/plain")
    @test parse(Int, HTTP.header(res, "Content-Length", "0")) == sizeof("test1")

    base_handler_http = function(request, state)
        @test request.target == "/test_path2"
        @test state isa TestState
        @test state.setting
        return HTTP.Response(200, "<html></html>")
    end

    state = TestState(true)
    test_handler = state_handler(base_handler_http, state)
    test_request = HTTP.Request("GET", "/test_path2")
    res = Dash.HttpHelpers.handle(test_handler, test_request)
     @test structsequal(res, test_handler(test_request))
     @test res.status == 200
    @test String(res.body) == "<html></html>"
    @test startswith(HTTP.header(res, "Content-Type", ""), "text/html")
    @test parse(Int, HTTP.header(res, "Content-Length", "0")) == sizeof("<html></html>")

    base_handler_js = function(request, state)
        @test request.target == "/test_path3"
        @test state isa TestState
        @test state.setting
        return HTTP.Response(200, ["Content-Type"=>"text/javascript"], body = "<html></html>")
    end

    test_handler = state_handler(base_handler_js, state)
    test_request = HTTP.Request("GET", "/test_path3")
    res = Dash.HttpHelpers.handle(test_handler, test_request)
     @test structsequal(res, test_handler(test_request))
     @test res.status == 200
    @test String(res.body) == "<html></html>"
    @test startswith(HTTP.header(res, "Content-Type", ""), "text/javascript")
    @test parse(Int, HTTP.header(res, "Content-Length", "0")) == sizeof("<html></html>")
end
@testset "compression" begin

    base_handler = function(request, state)
        @test request.target == "/test_path"
        @test state isa TestState
        @test state.setting
        return HTTP.Response(200, "test1")
    end

    state = TestState(true)
    handler = compress_handler(state_handler(base_handler, state))
    test_request = HTTP.Request("GET", "/test_path")
    HTTP.setheader(test_request, "Accept-Encoding" => "gzip")
    res = Dash.HttpHelpers.handle(handler, test_request)
    @test res.status == 200
    @test String(res.body) == "test1"
    @test !HTTP.hasheader(res, "Content-Encoding")

    base_handler = function(request, state)
        @test request.target == "/test_big"
        @test state isa TestState
        @test state.setting
        return HTTP.Response(200, repeat("<html></html>", 500))
    end

    test_request = HTTP.Request("GET", "/test_big")
    HTTP.setheader(test_request, "Accept-Encoding" => "gzip")
    handler = compress_handler(state_handler(base_handler, state))
    res = Dash.HttpHelpers.handle(handler, test_request)
    @test res.status == 200
    @test HTTP.header(res, "Content-Encoding") == "gzip"
    @test HTTP.header(res, "Content-Length") == string(sizeof(res.body))
    @test transcode(GzipDecompressor, res.body) == Vector{UInt8}(repeat("<html></html>", 500))
end

@testset "resource handler" begin
    test_registry = ResourcesRegistry(
        dash_dependency = (
            dev = ResourcePkg(
                "dash_renderer",
                "resources",
                [
                    Resource(
                        relative_package_path = ["props.min.js"],
                    )
                ]
            ),
            prod = ResourcePkg(
                "dash_renderer",
                "resources",
                [
                    Resource(
                        relative_package_path = ["props.min.js"],
                    )
                ]
            )
        ),
        dash_renderer = ResourcePkg(
            "dash_renderer",
            "resources",
            [
                Resource(
                    relative_package_path = "dash-renderer/dash_renderer.js",
                    dev_package_path = "dash-renderer/dash_renderer.js",
                )
            ]
        )
    )

    test_app = dash()
    handler = make_handler(test_app, test_registry)
    request = HTTP.Request("GET", "/_dash-component-suites/dash_renderer/dash-renderer/dash_renderer.js")
    resp = Dash.HttpHelpers.handle(handler, request)
    @test resp.status == 200
    @test String(resp.body) == "var a = [1,2,3,4,5,6]\n"
    @test HTTP.hasheader(resp, "ETag")
    @test HTTP.header(resp, "ETag") == bytes2hex(md5("var a = [1,2,3,4,5,6]\n"))
    @test HTTP.header(resp, "Content-Type") == "application/javascript"

    etag = HTTP.header(resp, "ETag")
    HTTP.setheader(request, "If-None-Match"=>etag)
    resp = Dash.HttpHelpers.handle(handler, request)
    @test resp.status == 304

    request = HTTP.Request("GET", "/_dash-component-suites/dash_renderer/props.min.js")
    resp = Dash.HttpHelpers.handle(handler, request)
    HTTP.setheader(request, "If-None-Match"=>bytes2hex(md5("var a = [1,2,3,4,5,6]")))
    @test resp.status == 200
    @test String(resp.body) == "var string = \"fffffff\"\n"
    @test HTTP.hasheader(resp, "ETag")
    @test HTTP.header(resp, "ETag") == bytes2hex(md5("var string = \"fffffff\"\n"))
    etag = HTTP.header(resp, "ETag")
    HTTP.setheader(request, "If-None-Match"=>etag)
    resp = Dash.HttpHelpers.handle(handler, request)
    @test resp.status == 304


    request = HTTP.Request("GET", "/_dash-component-suites/dash_renderer/props.v1_2_3m2333123.min.js")
    resp = Dash.HttpHelpers.handle(handler, request)
    HTTP.setheader(request, "If-None-Match"=>bytes2hex(md5("var a = [1,2,3,4,5,6]")))
    @test resp.status == 200
    @test String(resp.body) == "var string = \"fffffff\"\n"
    @test HTTP.hasheader(resp, "Cache-Control")

end

