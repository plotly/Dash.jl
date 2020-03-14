using Documenter, Dashboards

makedocs(
    sitename = "Dashboards",
    format = Documenter.HTML(),
    modules = [Dashboards],
    doctest = false,
    pages = [
        "index.md",
        "API Docs" => "api.md"
    ]
)

deploydocs(
    repo = "github.com/waralex/Dashboards.jl.git",
    target = "build"
)
