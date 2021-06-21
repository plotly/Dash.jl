using Pkg
Pkg.update()
Pkg.develop(path = ".")
Pkg.add("DashBase")
Pkg.add("HTTP")
Pkg.instantiate()
Pkg.build("Dash")
Pkg.build("HTTP")
Pkg.test("Dash", coverage=true)