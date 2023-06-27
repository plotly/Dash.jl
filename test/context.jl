using Dash
using Dash.Contexts
@testset "task context" begin
    storage = TaskContextStorage()
    @test !has_context(storage)
    with_context(storage, "test") do
        @test has_context(storage)
        @test get_context(storage) == "test"
        with_context(storage, "inner") do
            @test has_context(storage)
            @test get_context(storage) == "inner"
        end
        @test get_context(storage) == "test"
    end
    @test !has_context(storage)
end
@testset "multiple tasks context" begin
    storage = TaskContextStorage()
    @test !has_context(storage)
    with_context(storage, "test") do
        @test has_context(storage)
        @test get_context(storage) == "test"
        @sync begin
            @async begin
                @test !has_context(storage)
            end
            @async begin
                with_context(storage, "async_1") do
                    sleep(0.1)
                    @test get_context(storage) == "async_1"
                end
            end
            @async begin
                with_context(storage, "async_2") do
                    @test get_context(storage) == "async_2"
                end
            end
        end
        @test get_context(storage) == "test"

    end
    @test !has_context(storage)
end
