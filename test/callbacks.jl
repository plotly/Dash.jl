import HTTP, JSON2
using Test
using Dash



@testset "callback! single output" begin
    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div")        
        end

    callback!(app, Output("my-div", "children"), Input("my-id", "value")) do value
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

    handler = Dash.make_handler(app)
    test_json = """{"output":"my-div.children","changedPropIds":["my-id.value"],"inputs":[{"id":"my-id","property":"value","value":"test"}]}"""
    request = HTTP.Request("POST", "/_dash-update-component", [], Vector{UInt8}(test_json))
    response = HTTP.handle(handler, request)
    @test response.status == 200
    resp_obj = JSON2.read(String(response.body))
    @test !in(:multi, keys(resp_obj))
    @test resp_obj.response.props.children == "test"

end

@testset "callback! multi output" begin
    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    callback!(app, [Output("my-div","children"), Output("my-div2","children")], Input("my-id","value"), State("my-id","type")) do value, state
        return value, state
    end
    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("..my-div.children...my-div2.children.."))
    @test app.callbacks[Symbol("..my-div.children...my-div2.children..")].func("value", "state") == ("value", "state")

    handler = Dash.make_handler(app)
    test_json = """{"output":"..my-div.children...my-div2.children..","changedPropIds":["my-id.value"],"inputs":[{"id":"my-id","property":"value","value":"test"}], "state":[{"id":"my-id","property":"type","value":"state"}]}"""
    request = HTTP.Request("POST", "/_dash-update-component", [], Vector{UInt8}(test_json))
    response = HTTP.handle(handler, request)
    @test response.status == 200
    resp_obj = JSON2.read(String(response.body))
    @test in(:multi, keys(resp_obj))
    @test resp_obj.response[Symbol("my-div")].children == "test"
    @test resp_obj.response[Symbol("my-div2")].children == "state"

    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    callback!(app, [Output("my-div","children")], Input("my-id","value"), State("my-id","type")) do value, state
        return (value,)
    end
    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("..my-div.children.."))
    @test app.callbacks[Symbol("..my-div.children..")].func("value", "state") == ("value", )

    handler = Dash.make_handler(app)
    test_json = """{"output":"..my-div.children..","changedPropIds":["my-id.value"],"inputs":[{"id":"my-id","property":"value","value":"test"}], "state":[{"id":"my-id","property":"type","value":"state"}]}"""
    request = HTTP.Request("POST", "/_dash-update-component", [], Vector{UInt8}(test_json))
    response = HTTP.handle(handler, request)
    @test response.status == 200
    resp_obj = JSON2.read(String(response.body))
    @test in(:multi, keys(resp_obj))
    @test resp_obj.response[Symbol("my-div")].children == "test"

end
@testset "callback! multi output flat" begin
    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            dcc_input(id = "my-id2", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    callback!(app, Output("my-div","children"), Output("my-div2","children"),
                   Input("my-id","value"), Input("my-id", "value"), State("my-id","type")) do value, value2, state
        return value * value2, state
    end
    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("..my-div.children...my-div2.children.."))
    @test app.callbacks[Symbol("..my-div.children...my-div2.children..")].func("value", " value2", "state") == ("value value2", "state")

    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            dcc_input(id = "my-id2", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    callback!(app, Output("my-div","children"),
                   Input("my-id","value"), Input("my-id", "value")) do value, value2
        return value * value2
    end
    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("my-div.children"))
    @test app.callbacks[Symbol("my-div.children")].func("value", " value2") == "value value2"

end
@testset "callback! checks" begin

    app = dash()
     
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

    @test length(app.callbacks) == 2
    @test haskey(app.callbacks, Symbol("my-div.children"))
    @test haskey(app.callbacks, Symbol("my-div2.children"))
    @test app.callbacks[Symbol("my-div.children")].func("value") == "value"
    @test app.callbacks[Symbol("my-div2.children")].func("value") == "v_value"

    #output already exists
    @test_throws ErrorException callback!(app, Output("my-div2","children"), Input("my-id","value")) do value
        return "v_$(value)"
    end

    #output same as input
    @test_throws ErrorException callback!(app, 
        Output("my-id","value"),
        Input("my-id","value"),
        State("my-id","value")) do value
        return "v_$(value)"
    end

    #output same as input
    @test_throws ErrorException callback!(app, 
        Output("my-id","value"),
        [Input("my-id","value"), Input("my-div","children")]) do value
        return "v_$(value)"
    end

    #output same as input
    @test_throws ErrorException callback!(app, 
        [Output("my-id","value"), Output("my-div","children")],
        Input("my-id","value")) do value
        return "v_$(value)"
    end

    #empty input
    @test_throws ErrorException callback!(app, 
        [Output("my-id","value"), Output("my-div","children")],
        Input[]) do value
        return "v_$(value)"
    end


    #duplicated output
    @test_throws ErrorException callback!(app, 
        [Output("my-div","value"), Output("my-div","value")],
        Input("my-id","value")) do value
        return "v_$(value)"
    end

    app = dash()
     
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            dcc_input(id = "my-id2", value="initial value", type = "text"),
            html_div(id = "my-div"),
            html_div(id = "my-div2")    
        end
    #empty output 
    @test_throws ErrorException callback!(app, 
        Input("my-id","value")) do value
        return "v_$(value)"
    end
    #empty input 
    @test_throws ErrorException callback!(app, 
        Output("my-div2", "children")) do value
        return "v_$(value)"
    end

    #wrong args order 
    @test_throws ErrorException callback!(app, 
        Input("my-id","value"), Output("my-div", "children")) do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, 
        Output("my-div2", "children"), Input("my-id","value"), Output("my-div", "children")) do value
        return "v_$(value)"
    end

    @test_throws ErrorException callback!(app, 
        Output("my-div2", "children"), Input("my-id","value"), State("my-div", "children"), Input("my-id2", "value")) do value, value2
        return "v_$(value)"
    end

end

@testset "clientside callbacks function" begin
    app = dash()
    app.layout = html_div() do
            dcc_input(id = "my-id", value="initial value", type = "text"),
            html_div(id = "my-div")        
        end

    callback!(ClientsideFunction("namespace", "func_name"),app, Output("my-div","children"), Input("my-id","value"))

    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("my-div.children"))
    @test app.callbacks[Symbol("my-div.children")].func isa ClientsideFunction
    @test app.callbacks[Symbol("my-div.children")].func.namespace == "namespace"
    @test app.callbacks[Symbol("my-div.children")].func.function_name == "func_name"


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
        , app,
        Output("my-div", "children"),
        Input("my-id", "value")
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
