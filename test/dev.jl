using Test
using Dash
using JSON2
using HTTP
@testset "dev" begin
    r = Dash.load_meta("dash_core_components")
    c = Dash.generate_embeded_components()
    println(c)
end
