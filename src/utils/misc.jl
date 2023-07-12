using UUIDs

function format_tag(name ::String, attributes::Dict{String, String}, inner::String = ""; opened = false, closed = false)
    attrs_string = join(
        ["$k=\"$v\"" for (k, v) in attributes],
        " "
    )
    tag = "<$name $attrs_string"
    if closed
        tag *= "/>"
    elseif opened
        tag *= ">"
    else
        tag *= ">$inner</$name>"
    end
end

function interpolate_string(s::String; kwargs...)
    result = s
    for (k, v) in kwargs
        result = replace(result, "{%$(k)%}" =>  v)
    end
    return result
end

function validate_index(name::AbstractString, index::AbstractString, checks::Vector)
    missings = filter(checks) do check
        !occursin(check[2], index)
    end
    if !isempty(missings)
        error(
            string(
                "Missing item", (length(missings)>1 ? "s" : ""), " ",
                join(getindex.(missings, 1), ", "),
                " in ", name
            )
        )
    end
end

macro var_str(s)
    return Symbol(s)
end

function parse_props(s)
    function make_prop(part)
        m = match(r"^(?<id>[A-Za-z]+[\w\-\:\.]*)\.(?<prop>[A-Za-z]+[\w\-\:\.]*)$", strip(part))
        if isnothing(m)
            error("expected <id>.<property>[,<id>.<property>...] in $(part)")
        end

        return (Symbol(m[:id]), Symbol(m[:prop]))
    end

    props_parts = split(s, ",", keepempty = false)

    return map(props_parts) do part
        return make_prop(part)
    end
end

function generate_hash()
    return strip(string(UUIDs.uuid4()), '-')
end

sort_by_keys(data) =  (;sort!(collect(pairs(data)), by = (x)->x[1])...,)

sorted_json(data) = JSON3.write(sort_by_keys(data))
