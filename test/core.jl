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

    component_with_childs = html_div() do 
        html_a("fffff"),
        html_h1("fffff")
    end

    @test haskey(component_with_childs.props, :children) 
    @test component_with_childs.props[:children] isa Tuple{Component, Component}
    @test length(component_with_childs.props[:children]) == 2
    @test component_with_childs.props[:children][1].type == "A"
    @test component_with_childs.props[:children][2].type == "H1"

end

#=@testset "get ids set" begin
    comp = html_div(id = "id0") do
        html_div(id = "id1") do
            html_a(id = "id2")
        end,
        html_div() do
            html_div() do
                dcc_graph(id="id3")
            end
        end
    end

    ids = Dash.Components.collect_with_ids(comp)
    @test haskey(ids, :id0)
    @test ids[:id0].props[:id] == "id0"
    @test haskey(ids, :id1)
    @test haskey(ids, :id2)
    @test haskey(ids, :id3)

end=#


@testset "callid" begin
    id = callid"id1.prop1 => id2.prop2"
    @test id isa CallbackId
    @test length(id.state) == 0
    @test length(id.input) == 1
    @test length(id.output) == 1
    @test id.input[1] == (:id1, :prop1)
    @test id.output[1] == (:id2, :prop2)

    id = callid"{state1.prop1, state2.prop2} input1.prop1, input2.prop2 => output1.prop1, output2.prop2"
    @test id isa CallbackId
    @test length(id.state) == 2
    @test length(id.input) == 2
    @test length(id.output) == 2
    @test id.input[1] == (:input1, :prop1)
    @test id.input[2] == (:input2, :prop2)
    @test id.output[1] == (:output1, :prop1)
    @test id.output[2] == (:output2, :prop2)
    @test id.state[1] == (:state1, :prop1)
    @test id.state[2] == (:state2, :prop2)
end

@testset "callback!" begin
    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div")        
        end

    callback!(app, callid"my-id.value => my-div.children") do value
        return value
    end
    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("my-div.children"))
    @test app.callbacks[Symbol("my-div.children")].func("test") == "test"

    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    callback!(app, callid"{my-id.type} my-id.value => my-div.children, my-div2.children") do state, value
        return state, value
    end
    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("..my-div.children...my-div2.children.."))
    @test app.callbacks[Symbol("..my-div.children...my-div2.children..")].func("state", "value") == ("state", "value")

    app = dash()
     
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    
    callback!(app, callid"my-id.value => my-div.children") do value
        return value
    end
    callback!(app, callid"my-id.value => my-div2.children") do value
        return "v_$(value)"
    end

    @test length(app.callbacks) == 2
    @test haskey(app.callbacks, Symbol("my-div.children"))
    @test haskey(app.callbacks, Symbol("my-div2.children"))
    @test app.callbacks[Symbol("my-div.children")].func("value") == "value"
    @test app.callbacks[Symbol("my-div2.children")].func("value") == "v_value"

    @test_throws ErrorException callback!(app, callid"my-id.value => my-div2.children") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid"{my-id.value} my-id.value => my-id.value") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid"my-div.children, my-id.value => my-id.value") do value
        return "v_$(value)"
    end
    @test_throws ErrorException callback!(app, callid"my-id.value => my-div.children, my-id.value") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid" => my-div2.title, my-id.value") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid"my-id.value => my-div2.title, my-div2.title") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid"my-id.value => my-div2.title") do 
        return "v_"
    end
    

    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div("test2", id = "my-div"),
            html_div(id = "my-div2") do 
                html_h1("gggg", id = "my-h")
            end
        end
    callback!(app, callid"{my-id.type} my-id.value => my-div.children, my-h.children") do state, value
        return state, value
    end
    @test length(app.callbacks) == 1
end

@testset "handler" begin
    app = dash(external_stylesheets=["test.css"])
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    callback!(app, callid"my-id.value => my-div.children") do value
        return value
    end
    callback!(app, callid"my-id.value => my-div2.children") do value
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
    callback!(app, callid"my-id.children => my-div.children") do value
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
    callback!(app, callid"my-id.children => my-div.children, my-div2.children") do value
        no_update(), "test"
    end

    test_json = """{"output":"..my-div.children...my-div2.children..","changedPropIds":["my-id.children"],"inputs":[{"id":"my-id","property":"children","value":10}]}"""

    result = Dash._process_callback(app, test_json)
    @test length(result[:response]) == 1
    @test haskey(result[:response], Symbol("my-div2"))
    @test !haskey(result[:response], Symbol("my-div"))
    @test result[:response][Symbol("my-div2")][:children] == "test"
end

@testset "wildprops" begin
    app = dash(external_stylesheets=["test.css"])

    app.layout = html_div() do            
            html_div(;id = "my-div", var"data-attr" = "ffff"),
            html_div(;id = "my-div2", var"aria-attr" = "gggg")    
        end
    callback!(app, callid"my-div.children => my-div2.aria-attr") do v
    
    end
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
