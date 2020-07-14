import HTTP, JSON2
using Test
using Dash
using Inflate
@testset "Components" begin
    
    a_comp = html_a("test", id = "test-a")
    @test a_comp.type == "A"
    @test a_comp.namespace == "dash_html_components"
    @test a_comp.props[:id] == "test-a"
    @test a_comp.props[:children] == "test"
    
    input_comp = dcc_input(id = "test-input", type="text")
    @test input_comp.type == "Input"
    @test input_comp.namespace == "dash_core_components"
    @test input_comp.props[:id] == "test-input"
    @test input_comp.props[:type] == "text"
    
    @test_throws ArgumentError html_a(undefined_prop = "rrrr")

    component_with_children = html_div() do 
        html_a("fffff"),
        html_h1("fffff")
    end

    @test haskey(component_with_children.props, :children) 
    @test component_with_children.props[:children] isa Tuple{Component, Component}
    @test length(component_with_children.props[:children]) == 2
    @test component_with_children.props[:children][1].type == "A"
    @test component_with_children.props[:children][2].type == "H1"

end


@testset "handler" begin
    app = dash(external_stylesheets=["test.css"])
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    callback!(app, Output("my-div","children"), Input("my-id","value")) do value
        return value
    end
    callback!(app, Output("my-div2","children"), Input("my-id","value")) do value
        return "v_$(value)"
    end

    handler = Dash.make_handler(app)

    request = HTTP.Request("GET", "/")
    response = HTTP.handle(handler, request)
    @test response.status == 200
    body_str = String(response.body)
    
    request = HTTP.Request("GET", "/_dash-layout")
    response = HTTP.handle(handler, request)
    @test response.status == 200
    body_str = String(response.body)
    @test body_str == JSON2.write(app.layout)

    request = HTTP.Request("GET", "/_dash-dependencies")
    response = HTTP.handle(handler, request)
    @test response.status == 200
    body_str = String(response.body)
    resp_json = JSON2.read(body_str)
    
    @test resp_json isa Vector
    @test length(resp_json) == 2
    @test haskey(resp_json[1], :inputs)
    @test haskey(resp_json[1], :state)
    @test haskey(resp_json[1], :output)
    @test length(resp_json[1].inputs) == 1
    @test length(resp_json[1].state) == 0
    @test resp_json[1].inputs[1].id == "my-id"
    @test resp_json[1].inputs[1].property == "value"
    @test resp_json[1].output == "my-div.children"

    test_json = """{"output":"my-div.children","changedPropIds":["my-id.value"],"inputs":[{"id":"my-id","property":"value","value":"initial value3333"}]}"""
    request = HTTP.Request("POST", "/_dash-update-component", [], Vector{UInt8}(test_json))
    response = HTTP.handle(handler, request)
    @test response.status == 200
    body_str = String(response.body)
    
    @test body_str == """{"response":{"props":{"children":"initial value3333"}}}"""
end

@testset "layout as function" begin
    app = dash()
    global_id = "my_div2"
    layout_func = () -> begin
        html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = global_id)    
        end
    end 
    app.layout = layout_func
    handler = Dash.make_handler(app)
    request = HTTP.Request("GET", "/_dash-layout")

    response = HTTP.handle(handler, request)
    @test response.status == 200
    body_str = String(response.body)
    @test body_str == JSON2.write(layout_func())
    @test occursin("my_div2", body_str)

    global_id = "my_div3"
    response = HTTP.handle(handler, request)
    @test response.status == 200
    body_str = String(response.body)
    @test body_str == JSON2.write(layout_func())
    @test occursin("my_div3", body_str)

end

@testset "assets" begin
    app = dash(assets_folder = "assets")
    app.layout = html_div() do            
            html_img(src = "assets/test.png")             
        end
    @test Dash.get_assets_path(app) == joinpath(pwd(),"assets")
    handler = Dash.make_handler(app)
    request = HTTP.Request("GET", "/assets/test.png")
    response = HTTP.handle(handler, request)
    @test response.status == 200
    body_str = String(response.body)
    
    request = HTTP.Request("GET", "/assets/wrong.png")
    response = HTTP.handle(handler, request)
    @test response.status == 404
    body_str = String(response.body)
    
end

@testset "PreventUpdate and no_update" begin
    app = dash()

    app.layout = html_div() do
            html_div(10, id = "my-id"),
            html_div(id = "my-div")        
        end
    callback!(app,  Output("my-div","children"), Input("my-id","children")) do value
        throw(PreventUpdate())
    end

    handler = Dash.make_handler(app)

    test_json = """{"output":"my-div.children","changedPropIds":["my-id.children"],"inputs":[{"id":"my-id","property":"children","value":10}]}"""
        
    request = HTTP.Request("POST", "/_dash-update-component", [], Vector{UInt8}(test_json))
    response = HTTP.handle(handler, request)
    @test response.status == 204
    @test length(response.body) == 0

    app = dash()
    app.layout = html_div() do
            html_div(10, id = "my-id"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")          
        end
    callback!(app, [Output("my-div","children"), Output("my-div2","children")], Input("my-id","children")) do value
        no_update(), "test"
    end

    handler = Dash.make_handler(app)
    test_json = """{"output":"..my-div.children...my-div2.children..","changedPropIds":["my-id.children"],"inputs":[{"id":"my-id","property":"children","value":10}]}"""

    request = HTTP.Request("POST", "/_dash-update-component", [], Vector{UInt8}(test_json))
    response = HTTP.handle(handler, request)
    @test response.status == 200
    result = JSON2.read(String(response.body))
    @test length(result[:response]) == 1
    @test haskey(result[:response], Symbol("my-div2"))
    @test !haskey(result[:response], Symbol("my-div"))
    @test result[:response][Symbol("my-div2")][:children] == "test"
end


@testset "HTTP Compression" begin
    # test compression of assets
    app = dash(assets_folder = "assets_compressed", compress = true)
    app.layout = html_div() 
    handler = Dash.make_handler(app)

    # ensure no compression of assets when Accept-Encoding not passed
    request = HTTP.Request("GET", "/assets/bootstrap.css")
    body = read("assets_compressed/bootstrap.css", String)
    response = HTTP.handle(handler, request)
    @test String(response.body) == body
    @test !in("Content-Encoding"=>"gzip", response.headers)

    # ensure compression when Accept-Encoding = "gzip"
    request = HTTP.Request("GET", "/assets/bootstrap.css", ["Accept-Encoding"=>"gzip"])
    response = HTTP.handle(handler, request)
    @test String(inflate_gzip(response.body)) == body
    @test String(response.body) != body
    @test in("Content-Encoding"=>"gzip", response.headers)

    # test cases for compress = false
    app = dash(assets_folder = "assets", compress=false)
    app.layout = html_div() do
            html_div("test")
        end
end

@testset "layout validation" begin
    app = dash(assets_folder = "assets_compressed", compress = true)
    @test_throws ErrorException make_handler(app)
    app.layout = html_div(id="top") do
        html_div(id="second") do
            html_div("dsfsd", id = "inner1")
        end,
        html_div(id = "third") do
            html_div("dsfsd", id = "inner2")
        end
    end 
    make_handler(app)

    app.layout = html_div(id="top") do
        html_div(id="second") do
            html_div("dsfsd", id = "inner1")
        end,
        html_div(id = "second") do
            html_div("dsfsd", id = "inner2")
        end
    end 
    @test_throws ErrorException make_handler(app)
end
