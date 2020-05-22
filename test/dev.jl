using Test
using Dash
using JSON2
using SnoopCompile
using HTTP
@testset "dev" begin
external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]

styles = (
    pre = (
        border = "thin lightgrey solid",
        overflowX = "scroll"
    ),
)



app = dash(external_stylesheets=external_stylesheets) 
app.layout = html_div() do
        html_div(className="three columns") do
        end,
        html_div(className="three columns") do
        end,
        html_div(className="three columns") do
        end,
        html_div(className="three columns") do
        end
    end


function pretty_json(t)
    io = IOBuffer()
    JSON2.pretty(io, JSON2.write(t), offset = 2)
    return String(take!(io))
end

#inf_timing = @snoopi tmin = 0.1 run_server(app, "0.0.0.0", 8080)
precompile(Dash.make_handler, (Dash.DashApp,))
println("====")
@time handler = Dash.make_handler(app)
@time handler = Dash.make_handler(app)
println("====")
inf_timing = @snoopi HTTP.handle(handler, HTTP.Request("GET", "/")) 
t = 0.
for itm in inf_timing
    @show itm
    t += itm[1]
end
@show t
pc = SnoopCompile.parcel(inf_timing)
@show pc
SnoopCompile.write("venv/precompile", pc)
end
