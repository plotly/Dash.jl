#=
dev.jl is a draft file that I use during the development of a new functionality if I need to call some function, etc. and see how it works.
I.e. at the beginning of the development of a new functionality, I disable all tests except dev.jl,
after the overall architecture emerges, I disable dev.jl and start writing full-fledged tests
=#
using Test
using Dash
using JSON3
using HTTP
@testset "dev" begin
    r = Dash.load_meta("dash_core_components")
    c = Dash.generate_embeded_components()
    println(c)
end
