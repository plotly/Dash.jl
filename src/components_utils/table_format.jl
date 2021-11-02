module TableFormat
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

                nully = nothing,

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
            locale = deepcopy(f.locale),
            nully = f.nully,
            prefix = f.prefix,
            specifier = String(take!(spec_io))
        )
    end


    #=struct Format
        align ::Union{typeof(Align), Nothing}
        fill ::Union{Char, Nothing}
        group ::Union{typeof(Group), Bool, Nothing}
        padding ::Union{typeof(Padding), Bool, Nothing}
        padding_width ::Union{Integer, Nothing}
        precision ::Union{Integer, Nothing}
        scheme ::Union{typeof(Scheme), }
        sign,
        symbol,
        trim,

        #locale
        symbol_prefix,
        symbol_suffix,
        decimal_delimiter,
        group_delimiter,
        groups,

        #Nully
        nully,
        #Prefix
        si_prefix
        function Format(;
                locale = (),
                nully = "",
                prefix = Prefix.none,
                align = Align.default,
                fill = "",
                group = Group.no,
                width = "",
                padding = Padding.no,
                precision = "",
                sign = Sign.default,
                symbol = Symbol.no,
                trim = Trim.no,
                type = Scheme.default
            )
            return new(
                locale,
                nully,
                prefix,
                (
                    align = align,
                    fill = fill,
                    group = group,
                    width = width,
                    padding = padding,
                    precision = precision,
                    sign = sign,
                    symbol = symbol,
                    trim = trim,
                    type = type
                )
            )
        end
    end

    function format(;
        align,
        fill,
        group,
        padding,
        padding_width,
        precision,
        scheme,
        sign,
        symbol,
        trim,

        #locale
        symbol_prefix,
        symbol_suffix,
        decimal_delimiter,
        group_delimiter,
        groups,

        #Nully
        nully,
        #Prefix
        si_prefix
    )
    end=#
end
#=
import collections




Trim = get_named_tuple("trim", {"no": "", "yes": "~"})


class Format:
    def __init__(self, **kwargs):
        self._locale = {}
        self._nully = ""
        self._prefix = Prefix.none
        self._specifier = {
            "align": Align.default,
            "fill": "",
            "group": Group.no,
            "width": "",
            "padding": Padding.no,
            "precision": "",
            "sign": Sign.default,
            "symbol": Symbol.no,
            "trim": Trim.no,
            "type": Scheme.default,
        }

        valid_methods = [
            m for m in dir(self.__class__) if m[0] != "_" and m != "to_plotly_json"
        ]

        for kw, val in kwargs.items():
            if kw not in valid_methods:
                raise TypeError(
                    "{0} is not a format method. Expected one of".format(kw),
                    str(list(valid_methods)),
                )

            getattr(self, kw)(val)

    def _validate_char(self, value):
        self._validate_string(value)

        if len(value) != 1:
            raise ValueError("expected value to a string of length one")

    def _validate_non_negative_integer_or_none(self, value):
        if value is None:
            return

        if not isinstance(value, int):
            raise TypeError("expected value to be an integer")

        if value < 0:
            raise ValueError("expected value to be non-negative", str(value))

    def _validate_named(self, value, named_values):
        if value not in named_values:
            raise TypeError("expected value to be one of", str(list(named_values)))

    def _validate_string(self, value):
        if not isinstance(value, (str, u"".__class__)):
            raise TypeError("expected value to be a string")

    # Specifier
    def align(self, value):
        self._validate_named(value, Align)

        self._specifier["align"] = value
        return self

    def fill(self, value):
        self._validate_char(value)

        self._specifier["fill"] = value
        return self

    def group(self, value):
        if isinstance(value, bool):
            value = Group.yes if value else Group.no

        self._validate_named(value, Group)

        self._specifier["group"] = value
        return self

    def padding(self, value):
        if isinstance(value, bool):
            value = Padding.yes if value else Padding.no

        self._validate_named(value, Padding)

        self._specifier["padding"] = value
        return self

    def padding_width(self, value):
        self._validate_non_negative_integer_or_none(value)

        self._specifier["width"] = value if value is not None else ""
        return self

    def precision(self, value):
        self._validate_non_negative_integer_or_none(value)

        self._specifier["precision"] = ".{0}".format(value) if value is not None else ""
        return self

    def scheme(self, value):
        self._validate_named(value, Scheme)

        self._specifier["type"] = value
        return self

    def sign(self, value):
        self._validate_named(value, Sign)

        self._specifier["sign"] = value
        return self

    def symbol(self, value):
        self._validate_named(value, Symbol)

        self._specifier["symbol"] = value
        return self

    def trim(self, value):
        if isinstance(value, bool):
            value = Trim.yes if value else Trim.no

        self._validate_named(value, Trim)

        self._specifier["trim"] = value
        return self

    # Locale
    def symbol_prefix(self, value):
        self._validate_string(value)

        if "symbol" not in self._locale:
            self._locale["symbol"] = [value, ""]
        else:
            self._locale["symbol"][0] = value

        return self

    def symbol_suffix(self, value):
        self._validate_string(value)

        if "symbol" not in self._locale:
            self._locale["symbol"] = ["", value]
        else:
            self._locale["symbol"][1] = value

        return self

    def decimal_delimiter(self, value):
        self._validate_char(value)

        self._locale["decimal"] = value
        return self

    def group_delimiter(self, value):
        self._validate_char(value)

        self._locale["group"] = value
        return self

    def groups(self, groups):
        groups = (
            groups
            if isinstance(groups, list)
            else [groups]
            if isinstance(groups, int)
            else None
        )

        if not isinstance(groups, list):
            raise TypeError("expected groups to be an integer or a list of integers")
        if len(groups) == 0:
            raise ValueError(
                "expected groups to be an integer or a list of " "one or more integers"
            )

        for group in groups:
            if not isinstance(group, int):
                raise TypeError("expected entry to be an integer")

            if group <= 0:
                raise ValueError("expected entry to be a non-negative integer")

        self._locale["grouping"] = groups
        return self

    # Nully
    def nully(self, value):
        self._nully = value
        return self

    # Prefix
    def si_prefix(self, value):
        self._validate_named(value, Prefix)
        self._prefix = value
        return self

    def to_plotly_json(self):
        f = {}
        f["locale"] = self._locale.copy()
        f["nully"] = self._nully
        f["prefix"] = self._prefix
        aligned = self._specifier["align"] != Align.default
        f["specifier"] = "{}{}{}{}{}{}{}{}{}{}".format(
            self._specifier["fill"] if aligned else "",
            self._specifier["align"],
            self._specifier["sign"],
            self._specifier["symbol"],
            self._specifier["padding"],
            self._specifier["width"],
            self._specifier["group"],
            self._specifier["precision"],
            self._specifier["trim"],
            self._specifier["type"],
        )

        return f

=#