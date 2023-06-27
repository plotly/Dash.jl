using Test
using Dash
using Dash.TableFormat
import JSON3
@testset "named values" begin
   @test TableFormat.Align.left.value == "<"
   a = TableFormat.Align.default
   @test a == TableFormat.Align.default
   @test TableFormat.possible_values(TableFormat.Align) == "Align.default, Align.left, Align.right, Align.center, Align.right_sign"
   @test a != TableFormat.Align.left
   @test a != TableFormat.Scheme.default
end

@testset "specifier" begin
    f = Format()

    @test f.specifier[:align] == TableFormat.Align.default.value
    TableFormat.align!(f, TableFormat.Align.left)
    @test f.specifier[:align] == TableFormat.Align.left.value
    @test_throws ArgumentError TableFormat.align!(f, TableFormat.Group.no)

    TableFormat.fill!(f, '-')
    @test f.specifier[:fill] == "-"
    TableFormat.fill!(f, "+")
    @test f.specifier[:fill] == "+"
    @test_throws ArgumentError TableFormat.fill!(f, "++")


    TableFormat.group!(f, TableFormat.Group.yes)
    @test f.specifier[:group] == TableFormat.Group.yes.value

    TableFormat.group!(f, true)
    @test f.specifier[:group] == TableFormat.Group.yes.value
    TableFormat.group!(f, false)
    @test f.specifier[:group] == TableFormat.Group.no.value
    @test_throws ArgumentError TableFormat.group!(f, "ffff")

    TableFormat.padding!(f, TableFormat.Padding.yes)
    @test f.specifier[:padding] == TableFormat.Padding.yes.value
    TableFormat.padding!(f, true)
    @test f.specifier[:padding] == TableFormat.Padding.yes.value
    TableFormat.padding!(f, false)
    @test f.specifier[:padding] == TableFormat.Padding.no.value
    @test_throws ArgumentError TableFormat.padding!(f, "ffff")

    TableFormat.padding_width!(f, 100)
    @test f.specifier[:width] == 100
    TableFormat.padding_width!(f, nothing)
    @test f.specifier[:width] == ""
    @test_throws ArgumentError TableFormat.padding_width!(f, "ffff")
    @test_throws ArgumentError TableFormat.padding_width!(f, -10)

    TableFormat.precision!(f, 3)
    @test f.specifier[:precision] == ".3"
    TableFormat.precision!(f, nothing)
    @test f.specifier[:precision] == ""
    @test_throws ArgumentError TableFormat.precision!(f, "ffff")
    @test_throws ArgumentError TableFormat.precision!(f, -10)

    @test f.specifier[:type] == TableFormat.Scheme.default.value
    TableFormat.scheme!(f, TableFormat.Scheme.decimal)
    @test f.specifier[:type] == TableFormat.Scheme.decimal.value
    @test_throws ArgumentError TableFormat.scheme!(f, "ccc")

    @test f.specifier[:sign] == TableFormat.Sign.default.value
    TableFormat.sign!(f, TableFormat.Sign.negative)
    @test f.specifier[:sign] == TableFormat.Sign.negative.value
    @test_throws ArgumentError TableFormat.sign!(f, "ccc")

    @test f.specifier[:symbol] == TableFormat.DSymbol.no.value
    TableFormat.symbol!(f, TableFormat.DSymbol.yes)
    @test f.specifier[:symbol] == TableFormat.DSymbol.yes.value
    @test_throws ArgumentError TableFormat.symbol!(f, "ccc")

    @test f.specifier[:trim] == TableFormat.Trim.no.value
    TableFormat.trim!(f, TableFormat.Trim.yes)
    @test f.specifier[:trim] == TableFormat.Trim.yes.value
    TableFormat.trim!(f, false)
    @test f.specifier[:trim] == TableFormat.Trim.no.value
    @test_throws ArgumentError TableFormat.trim!(f, "ccc")

end

@testset "locale" begin
    f = Format()
    @test isempty(f.locale)
    TableFormat.symbol_prefix!(f, "lll")
    @test haskey(f.locale, :symbol)
    @test f.locale[:symbol][1] == "lll"
    @test f.locale[:symbol][2] == ""
    TableFormat.symbol_prefix!(f, "rrr")
    @test f.locale[:symbol][1] == "rrr"
    @test f.locale[:symbol][2] == ""


    f = Format()
    @test isempty(f.locale)
    TableFormat.symbol_suffix!(f, "lll")
    @test haskey(f.locale, :symbol)
    @test f.locale[:symbol][1] == ""
    @test f.locale[:symbol][2] == "lll"
    TableFormat.symbol_suffix!(f, "rrr")
    @test f.locale[:symbol][1] == ""
    @test f.locale[:symbol][2] == "rrr"

    TableFormat.symbol_prefix!(f, "kkk")
    @test f.locale[:symbol][1] == "kkk"
    @test f.locale[:symbol][2] == "rrr"

    f = Format()
    TableFormat.decimal_delimiter!(f, '|')
    @test f.locale[:decimal] == "|"
    TableFormat.group_delimiter!(f, ';')
    @test f.locale[:group] == ";"

    TableFormat.groups!(f, [3,3,3])
    @test f.locale[:grouping] == [3,3,3]

    TableFormat.groups!(f, [5])
    @test f.locale[:grouping] == [5]

    @test_throws ArgumentError TableFormat.groups!(f, Int[])
    @test_throws ArgumentError TableFormat.groups!(f, Int[-1,2])
end

@testset "nully & prefix" begin
    f = Format()
    TableFormat.nully!(f, "gggg")
    @test f.nully == "gggg"
    TableFormat.si_prefix!(f, TableFormat.Prefix.femto)
    @test f.prefix == TableFormat.Prefix.femto.value
end

@testset "Format creation" begin
    f = Format(
        align = Align.left,
        fill = "+",
        group = true,
        padding = Padding.yes,
        padding_width = 10,
        precision = 2,
        scheme = Scheme.decimal,
        sign = Sign.negative,
        symbol = DSymbol.yes,
        trim = Trim.yes,

        symbol_prefix = "tt",
        symbol_suffix = "kk",
        decimal_delimiter = ";",
        group_delimiter = ",",
        groups = [2, 2],
        nully = "f",
        si_prefix = Prefix.femto
    )

    @test f.specifier == Dict{Symbol, Any}(
        :align => Align.left.value,
        :fill => "+",
        :group => Group.yes.value,
        :padding => Padding.yes.value,
        :width => 10,
        :precision => ".2",
        :type => Scheme.decimal.value,
        :sign => Sign.negative.value,
        :symbol => DSymbol.yes.value,
        :trim => Trim.yes.value
    )

    @test f.nully == "f"
    @test f.prefix == Prefix.femto.value

    @test f.locale[:symbol] == ["tt", "kk"]
    @test f.locale[:decimal] == ";"
    @test f.locale[:group] == ","
    @test f.locale[:grouping] == [2,2]

end
