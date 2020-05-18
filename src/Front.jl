module Front
import JSON, JSON2, PlotlyBase


to_dash(t::Any) = t
from_dash(::Type{Any}, t::Any) = t


function from_dash(::Type{PlotlyBase.Plot}, t)
    data = PlotlyBase.GenericTrace[PlotlyBase.GenericTrace(tr) for tr in t.data]
    layout = PlotlyBase.Layout(t.layout)
    PlotlyBase.Plot(data, layout)
end

#FIXME It's not elegant, but I didn't find elegant soluiton
JSON2.write(io::IO, p::PlotlyBase.Plot; kwargs...) = write(io, JSON.json(p))
end
