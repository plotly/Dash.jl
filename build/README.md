# plotly/julia:ci

#### This Dockerfile is currently used to support integration and unit tests for [Dash.jl](https://github.com/plotly/Dash.jl).

## Usage

This image is pulled from within Dash.jl's [config.yml](https://github.com/plotly/Dash.jl/blob/dev/.circleci/config.yml):

```yaml
    docker:
      - image: plotly/julia:ci
```

## Publication details

[plotly/julia:ci](https://hub.docker.com/r/plotly/julia/tags)

## Limitations

The current revision of this Dockerfile fixes the Julia version at a given release, so only manual updating is possible. The image is based on `circleci/python:3.7-stretch-node-browsers` rather than the [docker-library](https://github.com/docker-library/julia) or [julia-latest](https://hub.docker.com/_/julia?tab=tags) images.
