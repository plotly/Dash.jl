using Test
using Dash
@testset "interpolate_string" begin
    test_str = """
    {%head%}
    blah blah blah blah blah blah blah blah blah blah
    {%middle%}
    da da da da da da da da da da da da da {%da%} da
    end    
    """
    inter = Dash.interpolate_string(test_str, head="hd", middle = :mmmm, da = 10)
    @test inter == """
    hd
    blah blah blah blah blah blah blah blah blah blah
    mmmm
    da da da da da da da da da da da da da 10 da
    end    
    """
end
