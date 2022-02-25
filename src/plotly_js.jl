import JSON

function DashBase.to_dash(p::PlotlyJS.SyncPlot)
    data = JSON.lower(p.plot)
    pop!(data, :config, nothing)
    return data
end

