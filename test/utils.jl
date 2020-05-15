using Test
using Dash: interpolate_string, build_fingerprint, parse_fingerprint_path
@testset "interpolate_string" begin
    test_str = """
    {%head%}
    blah blah blah blah blah blah blah blah blah blah
    {%middle%}
    da da da da da da da da da da da da da {%da%} da
    end    
    """
    inter = interpolate_string(test_str, head="hd", middle = :mmmm, da = 10)
    @test inter == """
    hd
    blah blah blah blah blah blah blah blah blah blah
    mmmm
    da da da da da da da da da da da da da 10 da
    end    
    """
end

@testset "fingerprint" begin
    test_url = "/test/test_test/file.js"
    fp = build_fingerprint(test_url, "1.3.4", 3112231)
    @test fp == "/test/test_test/file.v1_3_4m3112231.js"

    (origin, is_fp) = parse_fingerprint_path(fp)
    @test is_fp
    @test origin == test_url

    
    test_url = "/test/test_test/file.2.3.js"
    fp = build_fingerprint(test_url, "1.3.4", 3112231)
    @test fp == "/test/test_test/file.v1_3_4m3112231.2.3.js"

    (origin, is_fp) = parse_fingerprint_path(fp)
    @test is_fp
    @test origin == test_url

    (origin, is_fp) = parse_fingerprint_path(test_url) 
    @test !is_fp
    @test origin == test_url
end

using Dash: parse_includes
@testset "parse_includes" begin
    files = parse_includes(joinpath("hot_reload", "app.jl"))
    for f in ["app.jl", "file1.jl", "file2.jl", "file3.jl", "file4.jl"]
        @test abspath(joinpath("hot_reload", f)) in files
    end
end
