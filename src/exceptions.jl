struct InvalidCallbackReturnValue <: Exception
    msg::String
end

function Base.showerror(io::IO, ex::InvalidCallbackReturnValue)
    Base.write(io, "Invalid callback return value: ", ex.msg)
end