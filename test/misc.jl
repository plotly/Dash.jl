import HTTP, JSON2
using Test
using Dash


@testset "deps to json" begin
    @test JSON2.write(ALL) == "[\"ALL\"]"
    @test JSON2.write(MATCH) == "[\"MATCH\"]"
    @test JSON2.write(ALLSMALLER) == "[\"ALLSMALLER\"]"
    test_dep = Input((type = "test", index = MATCH), "value")
    @test JSON2.write(test_dep) == """{"id":{"type":"test","index":["MATCH"]},"property":"value"}"""
end

@testset "json keys sorted" begin
    test_dep = (type = "test", index = 1)
    test_dep2 = (index = 1, type = "test")
    test_json = Dash.sorted_json(test_dep)
    test_json2 = Dash.sorted_json(test_dep2)
    @test test_json == test_json2
    @test test_json == """{"index":1,"type":"test"}"""
end

@testset "id equality" begin
    @test ALL == ALL
    @test ALL != MATCH
    @test Input("a", "b") == Input("a", "b")
    @test Input("a", "b") != Input("a", "c")
    @test Input("a", "b") != Input("c", "b")

    @test Input("a", "b") == Output("a", "b")
    @test Input("a", "b") in [Output("a", "b"), Output("a", "c")]

    #wilds
    @test Input((a=1, b=2), "c") == Input((a=1, b=2), "c")
    @test Input((a=1, b=2), "c") == Output((a=1, b=2), "c")
    @test Input((a=1, b=2), "c") != Input((a=1, b=2), "e")

    @test Input((a=1, b=2), "c") != Output((a=1, e=2), "c") 

    @test Input((a=1, b=2), "c") != Output((a=1, b=3), "c") 

    @test Input((a=ALL, b=2), "c") == Output((a=1, b=2), "c")
    @test Input((a=ALL, b=3), "c") != Output((a=1, b=2), "c")

    @test Input((a=ALL, b=2), "c") == Output((a=1, b=ALL), "c")
    @test Input((a=MATCH, b=2), "c") == Output((a=1, b=2), "c")
    @test Input((a=1, b=2), "c") == Output((a=MATCH, b=2), "c")
    @test Input((a = ALLSMALLER, b=2), "c") != Output((a = MATCH, b=2), "c")

    @test Input((a=ALL, b=2), "c") in [Output((a=1, b="ssss"), "c"), Output((a=1, b=2), "c")]

    @test isequal(Output((a = ALL, b=2), "c"), Output((a = 1, b=2), "c"))
    @test  Output((a = ALL, b=2), "c") in [Output((a = 1, b=2), "c"), Output((a=2, b=2), "c")] 
    test = [Output((a = ALL, b=2), "c"), Output((a=2, b=2), "c"), Output((a = 1, b=2), "c")]
    @test !Dash.check_unique(test)

    test2 = [Output((a = 2, b=2), "c"), Output((a=2, b=2), "c"), Output((a = 1, b=2), "c")]
    @test !Dash.check_unique(test2)

    test2 = [Output((a = 2, b=2), "e"), Output((a=2, b=2), "c"), Output((a = 1, b=2), "c")]
    @test Dash.check_unique(test2)
end