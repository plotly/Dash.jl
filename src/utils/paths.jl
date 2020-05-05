function exe_path()
    isempty(Base.PROGRAM_FILE) && return nothing
    return realpath(Base.PROGRAM_FILE) 
end