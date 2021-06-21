using JSON3
function process_components_meta(metafile)
    metadata = JSON3.read(
        read(metafile, String)
        )
    result = []
    for (file, props) in metadata
        name = split(split(string(file), "/")[end], ".")[1]
        push!(result, make_component_meta(name, props))
    end
    return result
end

function make_component_meta(name, props)
    args = filter(filter_arg, props["props"])
    regular_args = filter(collect(keys(args))) do name
        !endswith(string(name), "-*")
    end
    wild_args =
        filter(collect(keys(args))) do name
            endswith(string(name), "-*")
        end
    return OrderedDict(
        :name => Symbol(name),
        :args => regular_args,
        :wild_args => [Symbol(replace(string(a), "-*"=>"")) for a in wild_args],
        :docstr => docstring(name, args, props["description"]),
    )
end


const _reserwed_words = Set(
    ["baremodule",
    "begin",
    "break",
    "catch",
    "const",
    "continue",
    "do",
    "else",
    "elseif",
    "end",
    "export",
    "false",
    "finally",
    "for",
    "function",
    "global",
    "if",
    "import",
    "let",
    "local",
    "macro",
    "module",
    "quote",
    "return",
    "struct",
    "true",
    "try",
    "using",
    "while"]
)
function is_reserved_world(w)
    return w in _reserwed_words
end

function filter_arg(argpair)
    name, props = argpair
    is_reserved_world(name) && return false
    if haskey(props, "type")
        arg_type = props["type"]["name"]
        return !in(arg_type, ["func", "symbol", "instanceOf"])
    end
    if "flowType" in props
        arg_type_name = props["flowType"]["name"]
        if arg_type_name == "signature"
            # This does the same as the PropTypes filter above, but "func"
            # is under "type" if "name" is "signature" vs just in "name"
            if !in("type", props["FlowType"]) || props["FlowType"]["type"] != "object"
                return false
            end
        end
        return true
    end
    return false
end

function docstring(name, props, description)
    article = lowercase(first(name)) in ['a', 'e', 'i', 'o', 'u'] ? "An " : "A "
    result = string(
        article, name, " component", "\n",
        description, "\n\n"
    )
    if haskey(props, :children)
        result *= arg_docstring("children", props[:children]) * "\n"
    end
    if haskey(props, :id)
         result *= arg_docstring("id", props[:id]) * "\n"
    end
    other_props = sort(
        collect(filter(v->!in(v.first, [:children, :id]), props)),
        lt = (a, b) -> a[1] < b[1]
    )
    result *= join(arg_docstring.(other_props), "\n")
    return result

end

_jl_type(::Val{:array}, type_object) = "Array"
_jl_type(::Val{:bool}, type_object) = "Bool"
_jl_type(::Val{:string}, type_object) = "String"
_jl_type(::Val{:object}, type_object) = "Dict"
_jl_type(::Val{:any}, type_object) = "Bool | Real | String | Dict | Array"
_jl_type(::Val{:element}, type_object) = "dash component"
_jl_type(::Val{:node}, type_object) = "a list of or a singular dash component, string or number"

_jl_type(::Val{:enum}, type_object) = join(
        string.(
            getindex.(type_object["value"], :value)
        ), ", "
    )

function _jl_type(::Val{:union}, type_object)
    join(
        filter(a->!isempty(a), jl_type.(type_object["value"])),
        " | "
    )
end

function _jl_type(::Val{:arrayOf}, type_object)
    result = "Array"
    if type_object["value"] != ""
        result *= string(" of ", jl_type(type_object["value"]), "s")
    end
    return result
end

_jl_type(::Val{:objectOf}, type_object) =
    string("Dict with Strings as keys and values of type ", jl_type(type_object["value"]))

function _jl_type(::Val{:shape}, type_object)
    child_names = join(string.(keys(type_object["value"])), ", ")
    result = "lists containing elements $(child_names)"
    result *= join(
        [
            arg_docstring(name, prop, prop["required"], get(prop, "description", ""), 1)
            for (name, prop) in type_object["value"]
        ]
    )
    return result
end
_jl_type(::Val{:exact}, type_object) = _jl_type(Val(:shape), type_object)
_jl_type(val, type_object) = ""


jl_type(type_object) = _jl_type(Val(Symbol(type_object["name"])), type_object)

arg_docstring(name_prop::Pair, indent_num = 0) = arg_docstring(name_prop[1], name_prop[2], indent_num)
arg_docstring(name, prop, indent_num = 0) =
    arg_docstring(
        string(name),
        haskey(prop, "type") ? prop["type"] : prop["flowType"],
        prop["required"],
        prop["description"],
        indent_num
    )

function arg_docstring(prop_name, type_object, required, description, indent_num)
    typename = jl_type(type_object)
    indent_spacing = repeat("   ", indent_num)
    if occursin("\n", typename)
        return string(
            indent_spacing, "- `", prop_name, "` ",
            "(", required ? "required" : "optional", "):",
            description, ". ",
            prop_name, " has the following type: ", typename
        )
    end

    return string(
        indent_spacing, "- `", prop_name, "` ",
            "(",
                 isempty(typename) ? "" : string(typename, "; "),
                required ? "required" : "optional",
            ")",
            isempty(description) ? "" : string(": ", description)
    )
end