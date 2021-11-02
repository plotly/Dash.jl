using Test
using Dash
using Dash.TableFormat
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

    @test f.specifier[:align] == TableFormat.Align.default
    TableFormat.align!(f, TableFormat.Align.left)
    @test f.specifier[:align] == TableFormat.Align.left
    @test_throws ArgumentError TableFormat.align!(f, TableFormat.Group.no)

    TableFormat.fill!(f, '-')
    @test f.specifier[:fill] == '-'


    TableFormat.group!(f, TableFormat.Group.yes)
    @test f.specifier[:group] == TableFormat.Group.yes

    TableFormat.group!(f, true)
    @test f.specifier[:group] == TableFormat.Group.yes
    TableFormat.group!(f, false)
    @test f.specifier[:group] == TableFormat.Group.no
    @test_throws ArgumentError TableFormat.group!(f, "ffff")

    TableFormat.padding!(f, TableFormat.Padding.yes)
    @test f.specifier[:padding] == TableFormat.Padding.yes
    TableFormat.padding!(f, true)
    @test f.specifier[:padding] == TableFormat.Padding.yes
    TableFormat.padding!(f, false)
    @test f.specifier[:padding] == TableFormat.Padding.no
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

    @test f.specifier[:type] == TableFormat.Scheme.default
    TableFormat.scheme!(f, TableFormat.Scheme.decimal)
    @test f.specifier[:type] == TableFormat.Scheme.decimal
    @test_throws ArgumentError TableFormat.scheme!(f, "ccc")

    @test f.specifier[:sign] == TableFormat.Sign.default
    TableFormat.sign!(f, TableFormat.Sign.negative)
    @test f.specifier[:sign] == TableFormat.Sign.negative
    @test_throws ArgumentError TableFormat.sign!(f, "ccc")

    @test f.specifier[:symbol] == TableFormat.DSymbol.no
    TableFormat.symbol!(f, TableFormat.DSymbol.yes)
    @test f.specifier[:symbol] == TableFormat.DSymbol.yes
    @test_throws ArgumentError TableFormat.symbol!(f, "ccc")

    @test f.specifier[:trim] == TableFormat.Trim.no
    TableFormat.trim!(f, TableFormat.Trim.yes)
    @test f.specifier[:trim] == TableFormat.Trim.yes
    TableFormat.trim!(f, false)
    @test f.specifier[:trim] == TableFormat.Trim.no
    @test_throws ArgumentError TableFormat.trim!(f, "ccc")

end

@testset "locale" begin
    f = Format()

    
end