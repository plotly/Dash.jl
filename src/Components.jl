module Components
    import JSON, JSON2, HTTP
    using DataStructures    
    const ROOT_PATH = (@__DIR__) * "/.."
    const META_FILENAME = ROOT_PATH * "/components_meta.json"
    
    struct ScriptPackage
        name ::String
        package_name ::String
        source_path ::String        
        scripts ::Vector{String}
        has_components ::Bool  
    end

    struct ComponentPropertyMeta
        name ::String
        required ::Bool
        description ::String
    end

    struct ComponentMeta
        name ::String
        description ::String
        properties ::Vector{ComponentPropertyMeta}         
    end

    Base.show(io::IO, meta::ComponentPropertyMeta) = println(io, "$(meta.name)$(meta.required ? " [Required]" : "") - $(meta.description)")
    function Base.show(io::IO, meta::ComponentMeta)

        println("$(meta.name):")
        println("$(meta.description)")
        println("\nParams:\n")
        for prop in values(meta.properties)
            show(prop)
            println("")
        end        
    end

    macro _make_packages()
        raw_meta = open(META_FILENAME, "r") do f            
            JSON2.read(f, Vector{ScriptPackage})
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
                    end
                )                
            end
        )
    end
    
    macro register_js_sources(router, prefix = "")
        registers = []
        for package in values(_components_packages)            
            for script in package.scripts
                filename = ROOT_PATH * package.source_path * script                
                part = quote
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

    function parse_props(raw_props::OrderedDict)
        result = Vector{ComponentPropertyMeta}()
        for (name, prop_meta) in raw_props
            push!(result, ComponentPropertyMeta(name, prop_meta["required"], prop_meta["description"]))
        end
        return result
    end

    function load_package_components(package::ScriptPackage)
        meta_filename = "$(ROOT_PATH)/$(package.source_path)metadata.json"
        raw_meta = JSON.parsefile(meta_filename, dicttype = OrderedDict{String, Any})
        components = Dict(map(values(raw_meta)) do meta
            Symbol(meta["displayName"]) => ComponentMeta(meta["displayName"], meta["description"], parse_props(meta["props"]))
        end)
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
        components = load_package_components(_components_packages[package])
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