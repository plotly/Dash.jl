import HTTP, JSON2
using Test
using Dash
struct TestChild
    a::Int32
    b::Int32
end
macro sym_str(s)
    return Symbol(s)
end
@testset "Front.to_dash" begin
    @test Front.to_dash((1,3)) == (1,3)
    Front.to_dash(t::TestChild) = "$(t.a)-$(t.b)"
    t = TestChild(10, 20)
    @test Front.to_dash(t) == "$(t.a)-$(t.b)"
end

@testset "Typed property conversion" begin
    Front.to_dash(t::TestChild) = "$(t.a)-$(t.b)"
    t = TestChild(10, 20)
    
    a_comp = html_a(t, id = "test-a")    
    @test a_comp.props[:children] == "$(t.a)-$(t.b)"
    
    a_comp = html_a(children = t, id = "test-a")    
    @test a_comp.props[:children] == "$(t.a)-$(t.b)"

    a_comp = html_a(id = "test-a") do
        return TestChild(10, 20)
    end   
    @test a_comp.props[:children] == "10-20"

end

@testset "Typed callback result conversion" begin
    Front.to_dash(t::TestChild) = "$(t.a)-$(t.b)"
    t = TestChild(10, 20)
    
    app = dash("Test app") do
        html_div() do
            html_div(10, id = "my-id"),
            html_div(id = "my-div")        
        end
    end
    callback!(app, callid"my-id.children => my-div.children") do value
        return TestChild(value, value)
    end

    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("my-div.children"))
    @test app.callbacks[Symbol("my-div.children")].func(10) == TestChild(10, 10)
    
    test_json = """{"output":"my-div.children","changedPropIds":["my-id.children"],"inputs":[{"id":"my-id","property":"children","value":10}]}"""
    result = Dash.process_callback(app, test_json)
    @test result[:response][:props][:children] == "10-10"

    app = dash("Test app") do
        html_div() do
            html_div(10, id = "my-id"),
            html_div(id = "my_div"),
            html_div(id = "my_div2")
        end
    end
    callback!(app, callid"my-id.children => my_div.children, my_div2.children") do value
        return TestChild(value, value), TestChild(value + 5, value + 5)
    end

    @test length(app.callbacks) == 1
    @test haskey(app.callbacks, Symbol("..my_div.children...my_div2.children.."))
    @test app.callbacks[Symbol("..my_div.children...my_div2.children..")].func(10) == (TestChild(10, 10), TestChild(15,15))
    
    test_json = """{"output":"..my_div.children...my_div2.children..","changedPropIds":["my-id.children"],"inputs":[{"id":"my-id","property":"children","value":10}]}"""
    result = Dash.process_callback(app, test_json)
    
    @test result[:response][:my_div][:children] == "10-10"
    @test result[:response][:my_div2][:children] == "15-15"

end

@testset "Front.from_dash" begin
    @test Front.from_dash(Any, (1,3)) == (1,3)
    function Front.from_dash(::Type{TestChild}, t)
        TestChild(parse.(Int32, split(t, "-"))...)
    end
    
    @test Front.from_dash(TestChild, "10-20") == TestChild(10, 20)
end

@testset "type_link" begin
    Front.to_dash(t::TestChild) = "$(t.a)-$(t.b)"
    function Front.from_dash(::Type{TestChild}, t)
        TestChild(parse.(Int32, split(t, "-"))...)
    end

    app = dash("Test app") do
        html_div() do
            html_div(TestChild(10,20), id = "my-id"),
            html_div("10-15", id = "my-div"),
            html_div(id = "output1"),
            html_div(id = "output2")
        end
    end
    link_type!(app, "my-id.children", TestChild)
    @test length(app.type_links) == 1
    @test Dash.callback_argument_type(app, "my-id", "children") == TestChild
    @test Dash.callback_argument_type(app, "my-id", "id") == Any
    @test Dash.callback_argument_type(app, "my-div", "children") == Any

    link_type!(app, "*.children", TestChild)
    @test length(app.type_links) == 4
    @test Dash.callback_argument_type(app, "my-id", "children") == TestChild
    @test Dash.callback_argument_type(app, "my-div", "children") == TestChild
    
    @test_throws ErrorException link_type!(app, "my-wrong.dddd", TestChild)

    callback!(app, callid"my-id.children => output1.children") do value
        @test value isa TestChild
        @test value == TestChild(5,10)
        return TestChild(20, 40)
    end
    callback!(app, callid"{my-div.children} my-id.children => output2.children") do state, value
        @test value isa TestChild
        @test state isa TestChild
        @test value == TestChild(5,10)
        @test state == TestChild(15,40)
        return TestChild(20, 40)
    end
    test_json = """{"output":"output1.children",
    "changedPropIds":["my-id.children"],
    "inputs":[{"id":"my-id","property":"children","value":"5-10"}]}"""
    result = Dash.process_callback(app, test_json)

    test_json2 = """{"output":"output2.children",
    "changedPropIds":["my-id.children"],
    "inputs":[{"id":"my-id","property":"children","value":"5-10"}],
    "state":[{"id":"my-div","property":"children","value":"15-40"}]
    }"""
    result = Dash.process_callback(app, test_json2)
    
end