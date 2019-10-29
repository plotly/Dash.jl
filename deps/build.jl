import JSON2, LibGit2
const ROOT_PATH = (@__DIR__) * "/.."
const META_FILENAME = ROOT_PATH * "/component_sources.json"
sources = open(META_FILENAME, "r") do f            
    JSON2.read(f)
end   
for source in sources
    if isdir(ROOT_PATH*"/"*source.path)
        rm(ROOT_PATH*"/"*source.path, force = true, recursive = true)
    end
    repo = LibGit2.clone(source.git, ROOT_PATH*"/"*source.path)    
    LibGit2.checkout!(repo, source.hash)
end