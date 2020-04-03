import HTTP, JSON2
using Test
using Dash
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

@testset "get ids set" begin
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

end

@testset "Dash creation" begin
    app = dash("test app"; external_stylesheets=["https://test.css"], url_base_pathname = "/") do
        html_div(id = "test-div")
    end
    @test app.name == "test app"
    @test app.external_stylesheets == ["https://test.css"]
    @test app.url_base_pathname == "/"
    @test app.layout.type == "Div"
    @test app.layout.props[:id] == "test-div"
    @test length(app.callable_components) == 1
    @test haskey(app.callable_components, Symbol("test-div"))
end

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
    app = dash("Test app") do
        html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div")        
        end
    end
    callback!(app, callid"my-id.value => my-div.children") do value
        return value
    end
    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("my-div.children"))
    @test app.callbacks[Symbol("my-div.children")].func("test") == "test"

    app = dash("Test app") do
        html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    end
    callback!(app, callid"{my-id.type} my-id.value => my-div.children, my-div2.children") do state, value
        return state, value
    end
    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("..my-div.children...my-div2.children.."))
    @test app.callbacks[Symbol("..my-div.children...my-div2.children..")].func("state", "value") == ("state", "value")

    app = dash("Test app") do
        html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
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

    @test_throws ErrorException callback!(app, callid"my-id-wrong.value => my-div2.style") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid"my-id.wrong_prop => my-div2.style") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid"my-id.value => my-div-wrong.style") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid"my-id.value => my-div.wrong-prop") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid"{my-id-wrong.type} my-id.value => my-div.wrong-prop") do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, callid"{my-id.wrong_prop} my-id.value => my-div.wrong-prop") do value
        return "v_$(value)"
    end

    app = dash("Test app") do
        html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div("test2", id = "my-div"),
            html_div(id = "my-div2") do 
                html_h1("gggg", id = "my-h")
            end
        end
    end
    callback!(app, callid"{my-id.type} my-id.value => my-div.children, my-h.children") do state, value
        return state, value
    end
    @test length(app.callbacks) == 1
end

@testset "handler" begin
    app = dash("Test app", external_stylesheets=["test.css"]) do
        html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    end
    callback!(app, callid"my-id.value => my-div.children") do value
        return value
    end
    callback!(app, callid"my-id.value => my-div2.children") do value
        return "v_$(value)"
    end

    handler = Dash.make_handler(app)

    request = HTTP.Request("GET", "/")
    response = handler(request)
    @test response.status == 200
    body_str = String(response.body)
    
    @test !isnothing(findfirst("test.css", body_str))
    @test !isnothing(findfirst("dash_html_components.min.js", body_str))
    @test !isnothing(findfirst("dash_core_components.min.js", body_str))

    request = HTTP.Request("GET", "/_dash-component-suites/dash_html_components/dash_html_components.min.js")
    response = handler(request)
    @test response.status == 200

    request = HTTP.Request("GET", "/_dash-component-suites/dash_core_components/dash_core_components.min.js")
    response = handler(request)
    @test response.status == 200

    request = HTTP.Request("GET", "/_dash-component-suites/dash_core_components/dash_wrong_components.min.js")
    response = handler(request)
    @test response.status == 404

    request = HTTP.Request("GET", "/_dash-layout")
    response = handler(request)
    @test response.status == 200
    body_str = String(response.body)
    @test body_str == JSON2.write(app.layout)

    request = HTTP.Request("GET", "/_dash-dependencies")
    response = handler(request)
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
    response = handler(request)
    @test response.status == 200
    body_str = String(response.body)
    
    @test body_str == """{"response":{"props":{"children":"initial value3333"}}}"""
end

@testset "assets" begin
    app = dash("Test app", assets_folder = "assets") do
        html_div() do            
            html_img(src = "assets/test.png")             
        end
    end
    @test app.assets_folder == "assets"
    handler = Dash.make_handler(app)
    request = HTTP.Request("GET", "/assets/test.png")
    response = handler(request)
    @test response.status == 200
    body_str = String(response.body)
    
    request = HTTP.Request("GET", "/assets/wrong.png")
    response = handler(request)
    @test response.status == 404
    body_str = String(response.body)
    
end

@testset "PreventUpdate and no_update" begin
    app = dash("Test app") do
        html_div() do
            html_div(10, id = "my-id"),
            html_div(id = "my-div")        
        end
    end
    callback!(app, callid"my-id.children => my-div.children") do value
        throw(PreventUpdate())
    end

    handler = Dash.make_handler(app)

    test_json = """{"output":"my-div.children","changedPropIds":["my-id.children"],"inputs":[{"id":"my-id","property":"children","value":10}]}"""
        
    request = HTTP.Request("POST", "/_dash-update-component", [], Vector{UInt8}(test_json))
    response = handler(request)
    @test response.status == 204
    @test length(response.body) == 0

    app = dash("Test app") do
        html_div() do
            html_div(10, id = "my-id"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")          
        end
    end
    callback!(app, callid"my-id.children => my-div.children, my-div2.children") do value
        no_update(), "test"
    end

    test_json = """{"output":"..my-div.children...my-div2.children..","changedPropIds":["my-id.children"],"inputs":[{"id":"my-id","property":"children","value":10}]}"""

    result = Dash.process_callback(app, test_json)
    @test length(result[:response]) == 1
    @test haskey(result[:response], Symbol("my-div2"))
    @test !haskey(result[:response], Symbol("my-div"))
    @test result[:response][Symbol("my-div2")][:children] == "test"
end

@testset "wildprops" begin
    app = dash("Test app", external_stylesheets=["test.css"]) do
        html_div() do            
            html_div(;id = "my-div", @prop("data-attr" = "ffff")),
            html_div(;id = "my-div2", @prop("aria-attr" = "gggg"))    
        end
    end
    callback!(app, callid"my-div.children => my-div2.aria-attr") do v
    
    end
end

@testset "pass changed props" begin
    app = dash("Test app") do
        html_div() do
            html_div(10, id = "my-id"),
            html_div(id = "my-div")        
        end
    end
    callback!(app, callid"my-id.children => my-div.children", pass_changed_props = true) do changed, value
        @test "my-id.children" in changed
        return value
    end

    handler = Dash.make_handler(app)

    test_json = """{"output":"my-div.children","changedPropIds":["my-id.children"],"inputs":[{"id":"my-id","property":"children","value":10}]}"""
        
    result = Dash.process_callback(app, test_json)
    @show result
    @test length(result[:response]) == 1
    
    @test result[:response][:props][:children] == 10

end