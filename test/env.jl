using Test
using Dash
using Dash:dash_env, @env_default!

@testset "env" begin
    @test isnothing(dash_env("test"))
    @test dash_env("test", "aaaa") == "aaaa"
    @test isnothing(dash_env(Int, "test"))
    @test dash_env(Int, "test", 10) == 10
    ENV["DASH_STRING_TEST"] = "test_path"
    @test dash_env("string_test", "aaaa") == "test_path"
    @test_throws ArgumentError dash_env(Int, "string_test", "aaaa") == "test_path"

    string_test = nothing
    @env_default! string_test
    @test string_test == "test_path"
    string_test = "aaaa"
    @env_default! string_test
    @test string_test == "aaaa"



    ENV["DASH_INT_TEST"] = "100"
    @test dash_env("int_test", "aaaa") == "100"
    @test dash_env(Int, "int_test", 50) == 100

    int_test = nothing
    @env_default! int_test Int
    @test int_test == 100
    int_test = 50
    @env_default! int_test Int
    @test int_test == 50
    int_test2 = nothing
    @env_default! int_test2 Int 40
    @test int_test2 == 40

    ENV["DASH_BOOL_TEST"] = "1"
    @test dash_env(Bool, "bool_test", 50) == true

    ENV["DASH_BOOL_TEST"] = "0"
    @test dash_env(Bool, "bool_test", 50) == false

    ENV["DASH_BOOL_TEST"] = "TRUE"
    @test dash_env(Bool, "bool_test", 50) == true

    ENV["DASH_BOOL_TEST"] = "FALSE"
    @test dash_env(Bool, "bool_test", 50) == false
end

@testset "prefixes" begin
    ENV["DASH_HOST"] = "localhost"
    @test dash_env("host") == "localhost"
    @test isnothing(dash_env("host", prefix = ""))

    @test dash_env(Int64, "port", 8050, prefix = "") == 8050
    ENV["PORT"] = "2001"
    @test isnothing(dash_env(Int64, "port"))
    @test dash_env(Int64, "port", prefix = "") == 2001
end