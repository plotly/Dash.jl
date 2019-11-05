module ComponentMetas    
    import JSON
    using DataStructures
    export ComponentPropertyMeta, ComponentMeta, load_components_meta

    include("Components.jl")
    using .Components

    struct ComponentPropertyMeta
        name ::String
        required ::Bool
        description ::String        
    end

    struct ComponentMeta
        name ::String
        description ::String
        properties ::OrderedDict{Symbol, ComponentPropertyMeta}         
    end
    
    

    Base.show(io::IO, meta::ComponentPropertyMeta) = println(io, "$(meta.name)$(meta.required ? "" : "[optional]") - $(meta.description)")
    
    function Base.show(io::IO, meta::ComponentMeta)

        println("$(meta.name):")
        println("$(meta.description)")
        println("\nParams:\n")
        for prop in values(meta.properties)
            show(prop)
            println("")
        end        
    end

    

    function is_prop_valid(prop_meta)
        
        if !haskey(prop_meta, "type") && !haskey(prop_meta, "flowType")
            return false
        end
        if haskey(prop_meta, "type")
            return !(prop_meta["type"]["name"] in ("func", "symbol", "instanceOf"))            
        end
        if haskey(prop_meta, "flowType")
            return prop_meta["flowType"]["name"] == "signature" &&
            (
                !("type" in prop_meta["flowType"]) ||
                 prop_meta["flowType"]["type"] != "object"
            )            
        end
        return false
    end
    
    function parse_props(raw_props::OrderedDict)
        result = OrderedDict{Symbol, ComponentPropertyMeta}()
        for (name, prop_meta) in raw_props
            if !isnothing(match(r"^[a-zA-Z_][a-zA-Z0-9_]+$", name)) && is_prop_valid(prop_meta)
                push!(result, 
                Symbol(name) => ComponentPropertyMeta(name, prop_meta["required"], prop_meta["description"])
                )
            end
        end
        return result
    end
    

    function load_components_meta(meta_filename::String)        
        raw_meta = JSON.parsefile(meta_filename, dicttype = OrderedDict{String, Any})
        components = Dict{Symbol, ComponentMeta}()
        for (script, meta) in raw_meta
            name = match(r"([a-zA-Z0-9_]+)(\.react)?\.js", script).captures[1]
            components[Symbol(name)] = ComponentMeta(name, meta["description"], parse_props(meta["props"]))
        end
        return components
    end
end