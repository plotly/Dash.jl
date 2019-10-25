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
        type ::Union{Symbol, Expr}
    end

    struct ComponentMeta
        name ::String
        description ::String
        properties ::OrderedDict{Symbol, ComponentPropertyMeta}         
    end
    
    

    Base.show(io::IO, meta::ComponentPropertyMeta) = println(io, "$(meta.name)::$(eval(meta.type))$(meta.required ? "" : " [optional]") - $(meta.description)")
    
    function Base.show(io::IO, meta::ComponentMeta)

        println("$(meta.name):")
        println("$(meta.description)")
        println("\nParams:\n")
        for prop in values(meta.properties)
            show(prop)
            println("")
        end        
    end

    function js_prop_types_mapping(js_type)
        mapping = (
            array = () -> :(Vector{Any}),
            bool = () -> :Bool,
            number = () -> :Number,
            string = () -> :(String),
            object = () -> :(Dict{Symbol, Any}),
            any = () -> :(Union{Bool, Number, String, Dict{Symbol, Any}, Vector}),
            element = () -> :(Dashboards.Components.Component),
            node = () -> :(Union{Dashboards.Components.Component, Vector{Dashboards.Components.Component}, String, Number}),
            enum = () -> :(Union{Bool, Number, String}), #TODO special type
            union = function()
                sub_types = map(js_type["value"]) do t
                    js_prop_types_mapping(t)
                end       
                return quote
                    $(eval(:(Union{$(sub_types...)})))
                end
            end,
            arrayOf = function()
                sub_type = js_prop_types_mapping(js_type["value"])
                return quote
                    $(eval(:(Vector{$(sub_type)})))
                end
            end,
            objectOf = function()
                sub_type = js_prop_types_mapping(js_type["value"])
                return quote
                    $(eval(:(Dict{Symbol, $(sub_type)})))
                end
            end,
            shape = () -> :(Dict{Symbol, Any}),
            exact = () -> :(Dict{Symbol, Any})
        )
        return :Any
        type_name = Symbol(js_type["name"])
        if !haskey(mapping, type_name)
            @show type_name
            return :Any
        else
            return mapping[type_name]()
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
            if is_prop_valid(prop_meta)
                push!(result, 
                Symbol(name) => ComponentPropertyMeta(name, prop_meta["required"], prop_meta["description"], js_prop_types_mapping(prop_meta["type"]))
                )
            end
        end
        return result
    end
    

    function load_components_meta(meta_filename::String)        
        raw_meta = JSON.parsefile(meta_filename, dicttype = OrderedDict{String, Any})
        components = Dict{Symbol, ComponentMeta}()
        for (script, meta) in raw_meta
            name = match(r"([a-zA-Z0-9_]+)\.react\.js", script).captures[1]
            components[Symbol(name)] = ComponentMeta(name, meta["description"], parse_props(meta["props"]))
        end
        return components
    end
end