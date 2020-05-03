abstract type AbstractRoute end
struct StaticRoute <: AbstractRoute
    url ::String
    StaticRoute(url) = new(url)
end
struct DynamicRoute{ST,VT} <: AbstractRoute
    segments_length ::Int
    static_segments ::ST
    variables ::VT
    tailed::Bool
    
    DynamicRoute(segments_length, static_segments::ST, variables::VT, tailed) where {ST, VT} = new{ST, VT}(segments_length, static_segments, variables, tailed)
end

function DynamicRoute(url::AbstractString)
    parts = split(url, '/', keepempty = false)
    segmets_vector = Tuple{Int, String}[]
    variables = Dict{Symbol, Int}()
    segments_count = 0
    for  part in parts
        segments_count += 1
        if length(part) > 2 && part[1] == '<' && part[end] == '>'
            var_name = Symbol(part[2:end-1])
            var_name in keys(variables) && ArgumentError("duplicated variable name $(var_name)")
            variables[var_name] = segments_count
        elseif part != "*"
            push!(segmets_vector,(segments_count, String(part)))
        end
    end
    #Route is tailed if it url hasn't / at end and the last segment is dynamic
    tailed = false
    if url[end] != '/' && (isempty(segmets_vector) || segmets_vector[end][1] != length(parts))
        tailed = true
    end 
    return DynamicRoute(
        segments_count,
        (segmets_vector...,),
        (;variables...),
        tailed
    )
end

struct RouteHandler{RT <: AbstractRoute, FT <: Function}
    route::RT
    handler::FT
    RouteHandler(route::RT, handler::FT) where {RT <: AbstractRoute, FT <: Function} = new{RT, FT}(route, handler)
end

function try_handle(route_handler::RouteHandler{StaticRoute, FT}, path::AbstractString, request::HTTP.Request, args...) where {FT}
    route_handler.route.url != path && return nothing
    return route_handler.handler(request, args...)
end

function args_tuple(route::DynamicRoute{ST, NamedTuple{Names, T}}, parts) where {ST, Names, T}
    return NamedTuple{Names}(getindex.(Ref(parts), values(route.variables)))
end
function try_handle(route_handler::RouteHandler{<:DynamicRoute, FT}, path::AbstractString, request::HTTP.Request, args...) where {FT}
    route = route_handler.route
    parts_length = route.segments_length
    limit = route.tailed ? parts_length : 0
    parts = split(lstrip(path, '/'), '/', limit = limit, keepempty = false)
    length(parts) != parts_length && return nothing
    for segment in route.static_segments
        parts[segment[1]] != segment[2] && return nothing
    end    
    return route_handler.handler(request, args...;args_tuple(route, parts)...)
end

function _make_route(url::AbstractString)
    parts = split(url, '/', keepempty = false)
    for part in parts
        if part == "*" || (length(part) > 2 && part[1] == '<' && part[end] == '>')
            return DynamicRoute(url)
        end
    end
    return StaticRoute(url)
end

struct Route{RH}
    method ::Union{Nothing,String}
    route_handler ::RH
    Route(method, route_handler::RH) where {RH} = new{RH}(method, route_handler)
end 
function Route(handler::Function, method, path::AbstractString) 
    return Route(
        method,
        RouteHandler(
            _make_route(path),
            handler
        )
    )
end
Route(handler::Function, path::AbstractString) = Route(handler, nothing, path)

function try_handle(route::Route, path::AbstractString, request::HTTP.Request, args...)
    (!isnothing(route.method) && route.method != request.method) && return nothing
    return try_handle(route.route_handler, path, request, args...)
end

@inline function _handle(route_tuple::Tuple, path::AbstractString, request::HTTP.Request, args...) 
    res = try_handle(route_tuple[1], path, request, args...)
    return !isnothing(res) ? 
            res :
            _handle(Base.tail(route_tuple), path, request, args...)
end

@inline function _handle(route_tuple::Tuple{}, path::AbstractString, request::HTTP.Request, args...) 
    return HTTP.Response(404)
end

function handle(route_tuple::Tuple, path::AbstractString, request::HTTP.Request, args...)::HTTP.Response
    return _handle(route_tuple, path, request, args...)
end

mutable struct Router
    routes::Tuple
    Router() = new(())
    Router(routes::Tuple{Vararg{Route}}) = new(routes)
end

function add_route!(router::Router, route::Route)
    router.routes = (router.routes..., route)
end
add_route!(handler::Function, router::Router, method, url) = add_route!(router, Route(handler, method, url))
add_route!(handler::Function, router::Router, url) = add_route!(handler, router, nothing, url)

function HTTP.handle(router::Router, request::HTTP.Request, args...)
    path = HTTP.URI(request.target).path
    return handle(router.routes, path, request, args...)
end