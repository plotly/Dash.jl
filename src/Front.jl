import JSON, JSON2, PlotlyBase

#FIXME It's not elegant, but I didn't find elegant solution
JSON2.write(io::IO, p::PlotlyBase.Plot; kwargs...) = write(io, JSON.json(p))
