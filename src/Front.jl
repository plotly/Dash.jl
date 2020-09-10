import JSON, JSON2, PlotlyBase

JSON2.write(io::IO, p::PlotlyBase.Plot; kwargs...) = write(io, JSON.json(p))
