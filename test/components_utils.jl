using Test
using Dash
using Base64
@testset "Send String" begin
    data = "test string"
    res = dcc_send_string(data, "test_file.csv"; type = "text/csv")
    @test res[:content] == data
    @test res[:filename] == "test_file.csv"
    @test res[:type] == "text/csv"
    @test !res[:base64]

    data2 = "test 2 string"
    res = dcc_send_string(data2, "test_file.csv"; type = "text/csv") do io, data
        write(io, data)
    end
    @test res[:content] == data2
    @test res[:filename] == "test_file.csv"
    @test res[:type] == "text/csv"
    @test !res[:base64]
end
@testset "Send Bytes" begin
    data = "test string"
    res = dcc_send_bytes(Vector{UInt8}(data), "test_file.csv"; type = "text/csv")
    @test res[:content] == Base64.base64encode(data)
    @test res[:filename] == "test_file.csv"
    @test res[:type] == "text/csv"
    @test res[:base64]

    data2 = "test 2 string"
    res = dcc_send_bytes(write, data2, "test_file.csv"; type = "text/csv")
    @test res[:content] == Base64.base64encode(data2)
    @test res[:filename] == "test_file.csv"
    @test res[:type] == "text/csv"
    @test res[:base64]
end
@testset "Send File" begin

    file = "assets/test.png"
    res = dcc_send_file(file, nothing; type = "text/csv")
    @test res[:content] == Base64.base64encode(read(file))
    @test res[:filename] == "test.png"
    @test res[:type] == "text/csv"
    @test res[:base64]

    file = "assets/test.png"
    res = dcc_send_file(file, "ttt.jpeg"; type = "text/csv")
    @test res[:content] == Base64.base64encode(read(file))
    @test res[:filename] == "ttt.jpeg"
    @test res[:type] == "text/csv"
    @test res[:base64]
end