using Pkg
Pkg.update()
Pkg.develop(path = ".")
Pkg.add("DashBase")
Pkg.add("DashHtmlComponents")
Pkg.add("DashCoreComponents")
Pkg.add("DashTable")
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