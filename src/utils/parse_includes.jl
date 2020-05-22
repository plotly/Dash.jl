function parse_elem!(file::AbstractString, ex::Expr, dest::Set{String})
    if ex.head == :call && ex.args[1] == :include && ex.args[2] isa String
        dir = dirname(file)
        include_file = normpath(joinpath(dir, ex.args[2]))
        parse_includes!(include_file, dest)
        return
    end
    for arg in ex.args
        parse_elem!(file, arg, dest)
    end
end
function parse_elem!(file::AbstractString, ex, dest::Set{String}) end

function parse_includes!(file::AbstractString, dest::Set{String})
    !isfile(file) && return
    file in dest && return
    push!(dest, abspath(file))

    ex = Base.parse_input_line(read(file, String); filename=file)
    parse_elem!(file, ex, dest)

end

function parse_includes(file::AbstractString)
    result = Set{String}()
    parse_includes!(file, result)
    return result
end