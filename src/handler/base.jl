function state_handler(base_handler, state)
    return function (request::HTTP.Request, args...)
        response = HTTP.handle(base_handler, request, state, args...)
        if response.status == 200
            HTTP.defaultheader!(response, "Content-Type" => HTTP.sniff(response.body))
            HTTP.defaultheader!(response, "Content-Length" => string(sizeof(response.body)))
        end 
        return response
    end
end

state_handler(base_handler::Function, state) = state_handler(HTTP.RequestHandlerFunction(base_handler), state)

function check_mime(message::HTTP.Message, mime_list)
    !HTTP.hasheader(message, "Content-Type") && return false
    mime_type = split(HTTP.header(message, "Content-Type", ""), ';')[1]
    return mime_type in mime_list
end

function prefix_handler(base_handler, prefix::String; add_lslash = true)
    return function(request::HTTP.Request, args...)
        !startswith(request.target, prefix) && return HTTP.Response(404)
        request.target = (add_lslash ? "/" : "") * request.target[length(prefix)+1:end]
        return HTTP.handle(base_handler, request, args...)
    end
end

function prefix_handler(base_handler::Function, prefix::String; add_lslash = true)
    prefix_handler(HTTP.RequestHandlerFunction(base_handler), prefix, add_lslash = add_lslash) 
end

const default_compress_mimes = ["text/html", "text/css", "text/xml", "application/json", "application/javascript"]
function compress_handler(base_handler; mime_types::Vector{String} = default_compress_mimes, compress_min_size = 500)
    return function(request::HTTP.Request, args...)
        response = HTTP.handle(base_handler, request, args...)
        if response.status == 200 && sizeof(response.body) >= compress_min_size &&
           occursin("gzip", HTTP.header(request, "Accept-Encoding", "")) && check_mime(response, mime_types)
            
           HTTP.setheader(response, "Content-Encoding" => "gzip")
           response.body = transcode(CodecZlib.GzipCompressor, response.body)
           HTTP.setheader(response, "Content-Length" => string(sizeof(response.body)))
            
        end
        return response
    end
end

function compress_handler(base_handler::Function; mime_types::Vector{String} = default_compress_mimes, compress_min_size = 500)
    return compress_handler(HTTP.RequestHandlerFunction(base_handler), mime_types = mime_types, compress_min_size = compress_min_size)
end