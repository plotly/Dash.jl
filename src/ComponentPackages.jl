module ComponentPackages
    import JSON, JSON2, HTTP
    
    
    include("ComponentMetas.jl")
    using .ComponentMetas    
    
    const ROOT_PATH = realpath(joinpath( @__DIR__, ".."))
    const META_FILENAME = joinpath(ROOT_PATH, "components_meta.json")

    struct ComponentPackage
        name ::String
        package_name ::String
        source_path ::String
        scripts ::NamedTuple{(:dev, :prod), Tuple{Vector{String}, Vector{String}}}
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

    function components_js_include(prefix = ""; debug=false)
        type = debug ? :dev : :prod
        join(
            map(values(_components_packages)) do p
                join(
                    map(p.scripts[type]) do script
                        """<script src="$(prefix)_dash-component-suites/$(p.package_name)/$(script)"></script>"""
                    end, "\n"
                )                
            end
        )
    end



    
    macro register_js_sources(path, prefix)
        registers = []
        for package in values(_components_packages)      
            package_uri = "_dash-component-suites/$(package.package_name)/"
            package_path = ROOT_PATH * package.source_path
            part = quote
                full_package_uri = $(prefix) * $(package_uri)
                if startswith($(path), full_package_uri)
                    script_name = replace($(path), full_package_uri=>"")
                    filename = $(package_path) * script_name
                    try
                        return HTTP.Response(200, ["Content-Type" => "application/javascript"], body = read(filename))
                    catch
                        return HTTP.Response(404)
                    end
                end                
            end            
            push!(registers, part)            
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
        
        meta_filename = joinpath(
            ROOT_PATH, 
            Sys.iswindows() ? replace(package.source_path[2:end-1], "/" =>"\\") : package.source_path,
            "metadata.json"
        ) 
        return load_components_meta(meta_filename)
        raw_meta = JSON.parsefile(meta_filename, dicttype = OrderedDict{String, Any})
        components = Dict{Symbol, ComponentMeta}()
        for (script, meta) in raw_meta
            name = match(r"([a-zA-Z0-9_]+)\.react\.js", script).captures[1]
            components[Symbol(name)] = ComponentMeta(name, meta["description"], parse_props(meta["props"]))
            break
        end
        return components
    end

    function component_doc_list()
        result = ""
        for package in values(_components_packages)
            if package.has_components
                result *= "## Component package: `$(package.name)`:\n"
                components = load_package_components(Symbol(package.name))
                names = sort(collect(keys(components)))
                names = map(names) do name
                    lowercase("`$(package.name)_$(name)`")
                end
                result *= join(names, ", ") * "\n"        
            end
        end
        return result
    end

    function make_component(package, component)
        maker_name = Symbol(lowercase(package.name),"_", lowercase(component.name))
        props = collect(keys(component.properties))
        add_signs = ""
        if any(x->x==:children, props)
            add_signs = """\n    $(maker_name)(children::Any;kwags...)\n    $(maker_name)(children_maker::Function;kwags...)\n"""
        end

        avaible_props = Set(Symbol.(getproperty.(values(component.properties), :name)))

        docstr = """    $(maker_name)(;kwags...)
        $(add_signs)

        $(component.description)

        # Arguments
        $(join(map(values(component.properties)) do prop
            "- `$(prop.name)` - $(prop.description)"
        end,"\n"))
        """
        makers = Vector{Expr}()
        push!(makers,esc(quote
            export $(maker_name)
            function $(maker_name) end
            @doc $(docstr) $(maker_name)
            function $(maker_name)(;kwargs...)
                avaible_props = $(avaible_props)
                result = Component($(component.name), $(package.package_name), Dict{Symbol, Any}(), avaible_props)
                for (prop, value) in pairs(kwargs)
                    if !(prop in avaible_props)
                        throw(ArgumentError("Invalid property $(string(prop)) for component " * $(string(maker_name))))
                    end
                    push!(result.props, prop=>Front.to_dash(value))
                end
                return result
            end                        
        end))
        if any(x->x==:children, props)
            props_nochildren = filter(x->x!=:children, props)
            push!(makers,esc(quote
                function $(maker_name)(children::Any;  kwargs...)
                    avaible_props = $(avaible_props)
                    result = Component($(component.name), $(package.package_name), Dict{Symbol, Any}(), avaible_props)
                    for (prop, value) in pairs(kwargs)
                        if !(prop in avaible_props)
                            throw(ArgumentError("Invalid property $(string(prop)) for component " * $(string(maker_name))))
                        end
                        push!(result.props, prop=>Front.to_dash(value))
                    end
                    push!(result.props, :children=>Front.to_dash(children))
                    return result
                end
                function $(maker_name)(children_maker::Function; kwargs...)
                    avaible_props = $(avaible_props)
                    result = Component($(component.name), $(package.package_name), Dict{Symbol, Any}(), avaible_props)
                    for (prop, value) in pairs(kwargs)
                        if !(prop in avaible_props)
                            throw(ArgumentError("Invalid property $(string(prop)) for component " * $(string(maker_name))))
                        end
                        push!(result.props, prop=>value)
                    end
                    push!(result.props, :children=>Front.to_dash(children_maker()))
                    return result
                end                        
        end))
        end
        
        return quote
            $(makers...)
        end    
    end

    macro reg_components()
        components_code::Vector{Expr} = []
        for package in values(_components_packages)
            if package.has_components
                components = ComponentPackages.load_package_components(package.name)
                for component in values(components)
                    push!(components_code, make_component(package, component))
                end
            end            
        end
        return quote 
            $(components_code...)
        end
        
    end
end