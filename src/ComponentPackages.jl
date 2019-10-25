module ComponentPackages
    import JSON, JSON2, HTTP
    

    include("ComponentMetas.jl")
    using .ComponentMetas
    #using .Components
    
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



    
    macro register_js_sources(path, prefix)
        registers = []
        for package in values(_components_packages)            
            for script in package.scripts
                filename = ROOT_PATH * package.source_path * script                
                part = quote
                    if $(path) == "/" * $(prefix)* "_dash-component-suites/" * $(package.package_name) * "/" * $(script)
                        try
                            return HTTP.Response(200, ["Content-Type" => "application/javascript"], body = read($(filename)))
                        catch
                            return HTTP.Respose(404)
                        end
                    end                                    
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

    function make_component(package, component)
        maker_name = Symbol(lowercase(package.name),"_", lowercase(component.name))
        props = collect(keys(component.properties))
        
        makers = Vector{Expr}()
        push!(makers,esc(quote
            export $(maker_name)
            function $(maker_name)(;$(map(x->Expr(:kw, :($(x)), nothing), props)...))
                result = Component($(component.name), $(package.package_name), Dict{Symbol, Any}())
                    $(map(props) do prop
                        :(
                            if !isnothing($(prop))
                                push!(result.props, ($(string(prop)))=>$(prop))
                            end
                        )                            
                    end...
                    )
                return result
            end                        
        end))
        if any(x->x==:children, props)
            props_nochildren = filter(x->x!=:children, props)
            push!(makers,esc(quote
                function $(maker_name)(children::Any; $(map(x->Expr(:kw, :($(x)), nothing), props_nochildren)...))
                    result = Component($(component.name), $(package.package_name), Dict{Symbol, Any}())
                        $(map(props) do prop
                            :(
                                if !isnothing($(prop))
                                    push!(result.props, ($(string(prop)))=>$(prop))
                                end
                            )                            
                        end...
                        )
                    return result
                end
                function $(maker_name)(children_maker::Function; $(map(x->Expr(:kw, :($(x)), nothing), props_nochildren)...))
                    result = Component($(component.name), $(package.package_name), Dict{Symbol, Any}())
                        children = children_maker()
                        $(map(props) do prop
                            :(
                                if !isnothing($(prop))
                                    push!(result.props, ($(string(prop)))=>$(prop))
                                end
                            )                            
                        end...
                        )
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
        #=
        @capture(expr, pack_.comp_(props__)) || error("expected <struct_name>:<package>.<component>(<properties>...)")
        
        components = ComponentPackages.load_package_components(pack)
        if !haskey(components, comp)
            error("undefined component $(comp) in package $(pack)")
        end
        component = components[comp]
                
        for prop in props@
            if !haskey(component.properties, prop)
                error("undefined property $(prop) for component $(name)")
            end
        end
        
        namespace = ComponentPackages.package_namespace(pack)
        type_name = string(comp)
        props_tuple = :(NamedTuple{$(props...,), Tuple{$(map(x->:(Any), props)...)}})
        
    
        if any(x->x==:children, props)
            children_prop = :(children::Any)
            filter!(x->x!=:children, props)        
            return esc(quote
                struct $(name) <: Dashboards.Components.ComponentContainer
                    type::String
                    namespace::String
                    props::$(props_tuple)                
                    function $(name)(children::Any = nothing; $(map(v->Expr(:kw, :($(v)), nothing), props)...))
                        new($(type_name), $(namespace), (children = children, $(map(v->:($(v)=$(v)), props)...),))
                    end
                end
                            
            end)        
        else
            return esc(quote
                struct $(name) <: Dashboards.Components.Component
                    type::String
                    namespace::String
                    props::$(props_tuple)
                    function $(name)(;$(map(v->Expr(:kw, :($(v)), nothing), props)...))
                        new($(type_name), $(namespace), ($(map(v->:($(v)=$(v)), props)...),))
                    end
                end            
            end)
        end=#    
    end
end