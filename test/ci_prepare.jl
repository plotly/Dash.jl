using Pkg
Pkg.update()
Pkg.add(PackageSpec(url="https://github.com/plotly/DashBase.jl.git"))
Pkg.add(PackageSpec(url="https://github.com/plotly/dash-html-components.git", rev="master"))
Pkg.add(PackageSpec(url="https://github.com/plotly/dash-core-components.git", rev="master"))
Pkg.add(PackageSpec(url="https://github.com/plotly/dash-table.git", rev="master"))
Pkg.add(PackageSpec(url="https://github.com/plotly/Dash.jl.git", rev=ENV["CIRCLE_BRANCH"]))
Pkg.add("HTTP")
Pkg.build("Dash")
Pkg.build("DashHtmlComponents")
Pkg.build("DashCoreComponents")
Pkg.build("HTTP")
Pkg.test("Dash", coverage=true)
function precompile_pkgs()
     for pkg in collect(keys(Pkg.installed()))
        if !isdefined(Symbol(pkg), :Symbol) && pkg != "Compat.jl"
            @info("Importing $(pkg)...")
            try (@eval import $(Symbol(pkg))) catch end
        end
    end
end
precompile_pkgs()