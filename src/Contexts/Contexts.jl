module Contexts

using DataStructures: Stack

export TaskContextStorage, with_context, has_context, get_context

mutable struct ContextItem{T}
    value::T
    ContextItem(value::T) where {T} = new{T}(value)
end

struct TaskContextStorage
    storage::Dict{UInt64, Stack{ContextItem}}
    guard::ReentrantLock
    TaskContextStorage() = new(Dict{UInt64, Stack{ContextItem}}(), ReentrantLock())
end

#threads are runing as tasks too, so this id also unique for different threads
curr_task_id() = objectid(current_task())

#thread unsafe should be used under locks
get_curr_stack!(context::TaskContextStorage) = get!(context.storage, curr_task_id(), Stack{ContextItem}())


function Base.push!(context::TaskContextStorage, item::ContextItem)
    lock(context.guard) do
        push!(get_curr_stack!(context), item)
    end
end

function Base.pop!(context::TaskContextStorage)
    return lock(context.guard) do
        return pop!(get_curr_stack!(context))
    end
end

function Base.isempty(context::TaskContextStorage)
    return lock(context.guard) do
        return isempty(get_curr_stack!(context))
    end
end

function with_context(f, context::TaskContextStorage, item::ContextItem)
    push!(context, item)
    result = f()
    pop!(context)
    return result
end

with_context(f, context::TaskContextStorage, item) = with_context(f, context, ContextItem(item))

has_context(context::TaskContextStorage) = !isempty(context)

function get_context(context::TaskContextStorage)
    return lock(context.guard) do
        isempty(context) && throw(ArgumentError("context is not set"))
        return first(get_curr_stack!(context)).value
    end
end

end
