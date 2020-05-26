import HTTP, JSON2
using Test
using Dash

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

    handler = make_handler(app)
    request = HTTP.Request("GET", "/_dash-dependencies")
    resp = HTTP.handle(handler, request)
    deps = JSON2.read(String(resp.body))

    @test length(deps) == 1
    cb = deps[1]
    @test cb.output == "my-div.children"
    @test cb.inputs[1].id == "my-id"
    @test cb.inputs[1].property == "value"
    @test :clientside_function in keys(cb)
    @test isnothing(cb.clientside_function)

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

@testset "clientside callbacks function" begin
    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div")        
        end

    callback!(ClientsideFunction("namespace", "func_name"),app, callid"my-id.value => my-div.children")

    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("my-div.children"))
    @test app.callbacks[Symbol("my-div.children")].func isa ClientsideFunction
    @test app.callbacks[Symbol("my-div.children")].func.namespace == "namespace"
    @test app.callbacks[Symbol("my-div.children")].func.function_name == "func_name"

    @test_throws ErrorException callback!(app, callid"my-id.value => my-div.children") do value
        return "v_$(value)"
    end

    handler = make_handler(app)
    request = HTTP.Request("GET", "/_dash-dependencies")
    resp = HTTP.handle(handler, request)
    deps = JSON2.read(String(resp.body))

    @test length(deps) == 1
    cb = deps[1]
    @test cb.output == "my-div.children"
    @test cb.inputs[1].id == "my-id"
    @test cb.inputs[1].property == "value"
    @test :clientside_function in keys(cb)
    @test cb.clientside_function.namespace == "namespace"
    @test cb.clientside_function.function_name == "func_name"
end 
@testset "clientside callbacks string" begin
    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div")        
        end

    callback!(
        """
        function(input_value) {
            return (
                parseFloat(input_value_1, 10)
            );
        }
        """
        , app, callid"my-id.value => my-div.children"
        )
    
    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("my-div.children"))
    @test app.callbacks[Symbol("my-div.children")].func isa ClientsideFunction
    @test app.callbacks[Symbol("my-div.children")].func.namespace == "_dashprivate_my-div"
    @test app.callbacks[Symbol("my-div.children")].func.function_name == "children"
    @test length(app.inline_scripts) == 1
    @test occursin("clientside[\"_dashprivate_my-div\"]", app.inline_scripts[1])
    @test occursin("ns[\"children\"]", app.inline_scripts[1])

    handler = make_handler(app)
    request = HTTP.Request("GET", "/_dash-dependencies")
    resp = HTTP.handle(handler, request)
    deps = JSON2.read(String(resp.body))

    @test length(deps) == 1
    cb = deps[1]
    @test cb.output == "my-div.children"
    @test cb.inputs[1].id == "my-id"
    @test cb.inputs[1].property == "value"
    @test :clientside_function in keys(cb)
    @test cb.clientside_function.namespace == "_dashprivate_my-div"
    @test cb.clientside_function.function_name == "children"
    request = HTTP.Request("GET", "/")
    resp = HTTP.handle(handler, request)
    body = String(resp.body)
    @test occursin("clientside[\"_dashprivate_my-div\"]", body)
    @test occursin("ns[\"children\"]", body)
end