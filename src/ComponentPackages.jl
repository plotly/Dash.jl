module ComponentPackages
    import JSON, JSON2, HTTP
    

    include("ComponentMetas.jl")
    using .ComponentMetas
    const ROOT_PATH = (@__DIR__) * "/.."
    const META_FILENAME = ROOT_PATH * "/components_meta.json"    

    struct ComponentPackage
        name ::String
        package_name ::String
        source_path ::String        
        scripts ::Vector{String}
        has_components ::Bool  
    end

    macro _make_packages()
        raw_meta = open(META_FILENAME, "r") do f            
            JSON2.read(f, Vector{ComponentPackage})
        end
        
        package_pairs = map(raw_meta) do p
            return :($(Symbol(p.name)) = $(p))
        end
        return esc(:($(package_pairs...),))
    end
    
    const _components_packages = @_make_packages

    macro components_js_include(prefix = "")
        join(
            map(values(_components_packages)) do p
                join(
                    map(p.scripts) do script
                        """<script src="/$(prefix)_dash-component-suites/$(p.package_name)/$(script)"></script>"""
                    end, "\n"
                )                
            end
        )
    end



    
    macro register_js_sources(target, prefix)
        registers = []
        for package in values(_components_packages)            
            for script in package.scripts
                filename = ROOT_PATH * package.source_path * script                
                part = quote
                    if $(target) == "/" * $(prefix)* "_dash-component-suites/" * $(package.package_name) * "/" * $(script)
                        return HTTP.Response(200, ["Content-Type" => "application/javascript"], body = read($(filename)))
                    end
                    HTTP.@register(
                        $(router),
                         "GET", 
                         "/" * $(prefix)* "_dash-component-suites/" * $(package.package_name) * "/" * $(script),                                            
                          function (req::HTTP.Request)
                             try
                                return HTTP.Response(200, ["Content-Type" => "application/javascript"], body = read($(filename)))
                             catch
                                return HTTP.Respose(404)
                             end                            
                          end 
                        )    
                
                end            
                push!(registers, part)
            end
        end
        return esc(quote
            $(registers...)
        end)
    end

    function package_namespace(package_name)
        return _components_packages[Symbol(package_name)].package_name
    end

    function load_package_components(package_name)
        package_symbol = Symbol(package_name)
        if !haskey(_components_packages, package_symbol)
            error("undefined package $(package_symbol)")
        end
        package = _components_packages[Symbol(package_name)]
        
        meta_filename = "$(ROOT_PATH)/$(package.source_path)metadata.json"
        return load_components_meta(meta_filename)
        raw_meta = JSON.parsefile(meta_filename, dicttype = OrderedDict{String, Any})
        components = Dict{Symbol, ComponentMeta}()
        for (script, meta) in raw_meta
            name = match(r"([a-zA-Z0-9_]+)\.react\.js", script).captures[1]
            components[Symbol(name)] = ComponentMeta(name, meta["description"], parse_props(meta["props"]))
        end
        return components
    end

    function show_packages()
        println("Components packages:")
        for package in values(_components_packages)
            if package.has_components
                println("\t$(package.name)")
            end
        end
    end

    function show_package_components(package, component = nothing)
        package = Symbol(package)
        component = isnothing(component) ? nothing : Symbol(component)
        if !haskey(_components_packages, package) || !_components_packages[package].has_components
            println("Compontents package \"$(package)\" not found")
        end
        components = load_package_components(package)
        if isnothing(component)
            names = sort(collect(keys(components)))            
            println("Components in \"$(package)\":")
            println(join(names, ", "))        
        elseif !haskey(components, component)
            println("Component \"$(component)\" not found in \"$(package)\"")
        else
            show(components[component])
        end        
    end


end