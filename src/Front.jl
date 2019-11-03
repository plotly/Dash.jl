module Front
import JSON, PlotlyBase


to_dash(t::Any) = t
from_dash(::Type{Any}, t::Any) = t

to_dash(t::PlotlyBase.Plot) = JSON.lower(t)
function from_dash(::Type{PlotlyBase.Plot}, t) 
    data = PlotlyBase.GenericTrace[PlotlyBase.GenericTrace(tr) for tr in t.data]
    layout = PlotlyBase.Layout(t.layout)
    PlotlyBase.Plot(data, layout)
end
end