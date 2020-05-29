import HTTP, JSON2
using Test
using Dash



@testset "callback!" begin
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
    @test app.callbacks[Symbol("..my-div.children...my-div2.children..")].func("state", "value") == ("state", "value")

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
