module TableFormat
    using JSON3
    export Format, Align, Group, Padding, Prefix, Scheme, Sign, DSymbol, Trim

    struct NamedValue{Name, T}
        value::T
        NamedValue{Name}(value::T) where {Name, Keys, T} = new{Name, T}(value)
    end

    struct TupleWithNamedValues{Name, Keys}
        values::NamedTuple
        TupleWithNamedValues{Name, Keys}(values) where {Name, Keys} = new{Name, Keys}(values)
    end

    Base.getproperty(tp::TupleWithNamedValues, prop::Symbol) = getfield(tp, :values)[prop]

    function tuple_with_named_values(name::Symbol, t::NamedTuple{Names}) where {Names}
        return TupleWithNamedValues{name, Names}((;zip(Names, NamedValue{name}.(values(t)))...))
    end

    function possible_values(::TupleWithNamedValues{Name, Keys}) where {Name, Keys}
        return join(string.(string(Name), ".", string.(Keys)), ", ")
    end

    const Align = tuple_with_named_values(:Align, (
        default = "",
        left = "<",
        right = ">",
        center = "^",
        right_sign = "="
    ))

    const Group = tuple_with_named_values(:Group, (
        no = "",
        yes = ","
    ))

    const Padding = tuple_with_named_values(:Padding, (no = "", yes =  0))

    const Prefix = tuple_with_named_values(:Prefix, (
        yocto = 10 ^ -24,
        zepto = 10 ^ -21,
        atto = 10 ^ -18,
        femto = 10 ^ -15,
        pico = 10 ^ -12,
        nano = 10 ^ -9,
        micro = 10 ^ -6,
        milli = 10 ^ -3,
        none = nothing,
        kilo = 10 ^ 3,
        mega = 10 ^ 6,
        giga = 10 ^ 9,
        tera = 10 ^ 12,
        peta = 10 ^ 15,
        exa = 10 ^ 18,
        zetta = 10 ^ 21,
        yotta = 10 ^ 24
    ))
    const Scheme = tuple_with_named_values(:Scheme, (
            default = "",
            decimal = "r",
            decimal_integer = "d",
            decimal_or_exponent = "g",
            decimal_si_prefix = "s",
            exponent = "e",
            fixed = "f",
            percentage = "%",
            percentage_rounded = "p",
            binary = "b",
            octal = "o",
            lower_case_hex = "x",
            upper_case_hex = "X",
            unicode = "c",
    ))
    const Sign = tuple_with_named_values(:Sign, (
        default = "",
        negative = "-",
        positive = "+",
        parantheses = "(",
        space = " "
    ))
    const DSymbol = tuple_with_named_values(:DSymbol, (
        no = "",
        yes = "\$",
        binary = "#b",
        octal = "#o",
        hex = "#x"
    ))
    const Trim = tuple_with_named_values(:Trim, (
        no = "",
        yes = "~"
    ))

    mutable struct Format
        locale
        nully
        prefix
        specifier
        function Format(;
                align = Align.default,
                fill = nothing,
                group = Group.no,
                padding = Padding.no,
                padding_width = nothing,
                precision = nothing,
                scheme = Scheme.default,
                sign = Sign.default,
                symbol = DSymbol.no,
                trim = Trim.no,

                symbol_prefix = nothing,
                symbol_suffix = nothing,
                decimal_delimiter = nothing,
                group_delimiter = nothing,
                groups = nothing,

                nully = "",

                si_prefix = Prefix.none
            )
            result = new(
                Dict(),
                "",
                Prefix.none.value,
                Dict{Symbol, Any}()
            )
            align!(result, align)
            fill!(result, fill)
            group!(result, group)
            padding!(result, padding)
            padding_width!(result, padding_width)
            precision!(result, precision)
            scheme!(result, scheme)
            sign!(result, sign)
            symbol!(result, symbol)
            trim!(result, trim)

            !isnothing(symbol_prefix) && symbol_prefix!(result, symbol_prefix)
            !isnothing(symbol_suffix) && symbol_suffix!(result, symbol_suffix)
            !isnothing(decimal_delimiter) && decimal_delimiter!(result, decimal_delimiter)
            !isnothing(group_delimiter) && group_delimiter!(result, group_delimiter)
            !isnothing(groups) && groups!(result, groups)
            !isnothing(nully) && nully!(result, nully)
            !isnothing(si_prefix) && si_prefix!(result, si_prefix)

            return result
        end
    end

    function check_named_value(t::TupleWithNamedValues{Name, Keys}, v::NamedValue{ValueName}) where {Name, ValueName, Keys}
        Name != ValueName && throw(ArgumentError("expected value to be one of $(possible_values(t))"))
        return true
    end
    function check_named_value(t::TupleWithNamedValues{Name, Keys}, v) where {Name, Keys}
        throw(ArgumentError("expected value to be one of $(possible_values(t))"))
    end

    check_char_value(v::Char) = string(v)
    function check_char_value(v::String)
        length(v) > 1 && throw(ArgumentError("expected char or string of length one"))
        return v
    end
    function check_char_value(v)
        throw(ArgumentError("expected char or string of length one"))
    end

    function check_int_value(v::Integer)
        v < 0 && throw(ArgumentError("expected value to be non-negative"))
    end

    function check_int_value(v)
        throw(ArgumentError("expected value to be Integer"))
    end

    function align!(f::Format, value)
        check_named_value(Align, value)
        f.specifier[:align] = value.value
    end

    function fill!(f::Format, value)
        if isnothing(value)
            f.specifier[:fill] = ""
            return
        end
        v = check_char_value(value)
        f.specifier[:fill] = v
    end


    function group!(f::Format, value)
        if value isa Bool
            value = value ? Group.yes : Group.no
        end
        check_named_value(Group, value)
        f.specifier[:group] = value.value
    end

    function padding!(f::Format, value)
        if value isa Bool
            value = value ? Padding.yes : Padding.no
        end
        check_named_value(Padding, value)
        f.specifier[:padding] = value.value
    end

    function padding_width!(f::Format, value)
        if isnothing(value)
            f.specifier[:width] = ""
        else
            check_int_value(value)
            f.specifier[:width] = value
        end
    end

    function precision!(f::Format, value)
        if isnothing(value)
            f.specifier[:precision] = ""
        else
            check_int_value(value)
            f.specifier[:precision] = ".$value"
        end
    end

    function scheme!(f::Format, value)
        check_named_value(Scheme, value)
        f.specifier[:type] = value.value
    end

    function sign!(f::Format, value)
        check_named_value(Sign, value)
        f.specifier[:sign] = value.value
    end

    function symbol!(f::Format, value)
        check_named_value(DSymbol, value)
        f.specifier[:symbol] = value.value
    end

    function trim!(f::Format, value)
        if value isa Bool
            value = value ? Trim.yes : Trim.no
        end
        check_named_value(Trim, value)
        f.specifier[:trim] = value.value
    end

    # Locale
    function symbol_prefix!(f::Format, value::AbstractString)
        if !haskey(f.locale, :symbol)
            f.locale[:symbol] = [value, ""]
        else
            f.locale[:symbol][1] = value
        end
    end

    function symbol_suffix!(f::Format, value::AbstractString)
        if !haskey(f.locale, :symbol)
            f.locale[:symbol] = ["", value]
        else
            f.locale[:symbol][2] = value
        end
    end

    function decimal_delimiter!(f::Format, value)
        v = check_char_value(value)
        f.locale[:decimal] = v
    end

    function group_delimiter!(f::Format, value)
        v = check_char_value(value)
        f.locale[:group] = v
    end

    function groups!(f::Format, value::Union{Vector{<:Integer}, <:Integer})
        groups = value isa Integer ? [value] : value
        isempty(groups) && throw(ArgumentError("groups cannot be empty"))

        for g in groups
            g < 0 && throw(ArgumentError("group entry must be non-negative integer"))
        end
        f.locale[:grouping] = groups
    end

    # Nully
    function nully!(f::Format, value)
        f.nully = value
    end

    # Prefix
    function si_prefix!(f::Format, value)
        check_named_value(Prefix, value)
        f.prefix = value.value
    end

    JSON3.StructTypes.StructType(::Type{Format}) = JSON3.RawType()

    function JSON3.rawbytes(f::Format)
        aligned = f.specifier[:align] != Align.default.value
        fill = aligned ? f.specifier[:fill] : ""
        spec_io = IOBuffer()
        print(spec_io,
            aligned ? f.specifier[:fill] : "",
            f.specifier[:align],
            f.specifier[:sign],
            f.specifier[:symbol],
            f.specifier[:padding],
            f.specifier[:width],
            f.specifier[:group],
            f.specifier[:precision],
            f.specifier[:trim],
            f.specifier[:type]
        )
        return JSON3.write(
            (
                locale = deepcopy(f.locale),
                nully = f.nully,
                prefix = f.prefix,
                specifier = String(take!(spec_io))
            )
        )
    end

    money(decimals, sign = Sign.default) = Format(
        group=Group.yes,
        precision=decimals,
        scheme=Scheme.fixed,
        sign=sign,
        symbol=Symbol.yes
    )


    function percentage(decimals, rounded::Bool=false)
        scheme = rounded ? Scheme.percentage_rounded : Scheme.percentage
        return Format(scheme = scheme, precision = decimals)
    end
end