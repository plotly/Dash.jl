import TOML
using OrderedCollections
using Conda
using PyCall
import YAML
using Pkg.Artifacts
import GitHub
import GitHub: gh_get_json, DEFAULT_API
using HTTP
import JSON
using ghr_jll

include("generator/generator.jl")

sources = TOML.parsefile(joinpath(@__DIR__, "Sources.toml"))

build_dir = joinpath(@__DIR__, "build")

artifact_file = joinpath(@__DIR__, "..", "Artifacts.toml")

generate(ARGS, sources, build_dir, artifact_file)