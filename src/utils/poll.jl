struct WatchState
    filename::String
    mtime ::Float64
    WatchState(filename) = new(filename, mtime(filename))
end
function poll_until_changed(files::Set{String}; interval = 1.)
    watched = WatchState[]
    for f in files
        !isfile(f) && return
        push!(watched, WatchState(f))
    end
    active = true
    while active
        for w in watched
            if !isfile(w.filename) 
                active = false
                break;
            end
            if mtime(w.filename) != w.mtime
                active = false
                break;
            end
            sleep(0.1)
        end
        sleep(interval)
    end
end