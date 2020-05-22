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
        end
        sleep(interval)
    end
end

function poll_folders(on_change, folders; interval = 1.)
    watched = Dict{String, Float64}()
    while true
        walked = Set{String}()
        for folder in folders
            !isdir(folder) && continue
            for (base, _, files) in walkdir(folder)
                for f in files
                    path = joinpath(base, f)   
                    new_time = mtime(path)
                    if new_time > get(watched, path, -1.) 
                        on_change(path, new_time, false)
                    end
                    watched[path] = new_time
                    push!(walked, path)
                end
            end
        end

        for path in keys(watched)
            if !(path in walked)
                on_change(path, -1., true)
                delete!(watched, path)
            end
        end
        sleep(interval)
    end
end