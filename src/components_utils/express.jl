import Base64
export dcc_send_file, dcc_send_string, dcc_send_bytes
"""
    dbc_send_file(path::AbstractString, filename = nothing; type = nothing)

Convert a file into the format expected by the Download component.

# Arguments
- `path` - path to the file to be sent
- `filename` - name of the file, if not provided the original filename is used
- `type` - type of the file (optional, passed to Blob in the javascript layer)
"""
function dcc_send_file(path, filename = nothing; type = nothing)
    filename = isnothing(filename) ? basename(path) : filename
    return dcc_send_bytes(read(path), filename, type = type)
end

"""
    dcc_send_bytes(src::AbstractVector{UInt8}, filename; type = nothing)
    dcc_send_bytes(src::Function, filename; type = nothing)

Convert vector of bytes into the format expected by the Download component.

# Examples

Sending binary content
```julia
file_data = read("path/to/file")
callback!(app, Output("download", "data"), Input("download-btn", "n_clicks"), prevent_initial_call = true) do n_clicks
    return dcc_send_bytes(file_data, "filename.fl")
end
```

Sending `DataFrame` in `Arrow` format
```julia
using DataFrames, Arrow
...
df = DataFrame(...)
callback!(app, Output("download", "data"), Input("download-btn", "n_clicks"), prevent_initial_call = true) do n_clicks
    return dcc_send_bytes("df.arr") do io
        Arrow.write(io, df)
    end
end
```
"""
function dcc_send_bytes(src::AbstractVector{UInt8}, filename; type = nothing)

    return Dict(
        :content => Base64.base64encode(src),
        :filename => filename,
        :type => type,
        :base64 => true
    )
end

function dcc_send_bytes(src::Function, filename; type = nothing)
    io = IOBuffer()
    src(io)
    return dcc_send_bytes(take!(io), filename, type = type)
end

"""
    dcc_send_data(src::AbstractString, filename; type = nothing)
    dcc_send_data(src::Function, filename; type = nothing)

Convert string into the format expected by the Download component.
`src` is a string or function that takes a single argument - io and writes data to it

# Examples

Sending string content
```julia
text_data = "this is the test"
callback!(app, Output("download", "data"), Input("download-btn", "n_clicks"), prevent_initial_call = true) do n_clicks
    return dcc_send_string(text_data, "text.txt")
end
```

Sending `DataFrame` in `CSV` format
```julia
using DataFrames, CSV
...
df = DataFrame(...)
callback!(app, Output("download", "data"), Input("download-btn", "n_clicks"), prevent_initial_call = true) do n_clicks
    return dcc_send_string("df.csv") do io
        CSV.write(io, df)
    end
end
```
"""
function dcc_send_string(src::AbstractString, filename; type = nothing)

    return Dict(
        :content => src,
        :filename => filename,
        :type => type,
        :base64 => false
    )
end

function dcc_send_string(src::Function, filename; type = nothing)
    io = IOBuffer()
    src(io)
    return dcc_send_string(String(take!(io)), filename, type = type)
end