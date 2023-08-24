# Contributor Guide

## Git

We use the `dev` branch for development. All feature branches should be based
off `dev`.

The `master` branch corresponds to the latest release. We deploy to [Julia
General Registry][jgr] and `git tag -a` off `master`.

## Running the unit tests (aka Julia tests)

```sh
git clone git@github.com:plotly/Dash.jl.git
cd Dash.jl
julia
```

```jl
julia> import Pkg
julia> Pkg.activate(".")
julia> Pkg.instantiate()
julia> Pkg.update()
julia> Pkg.test()
```

To run the unit tests for multiple versions of Julia, we recommend using [`juliaup`][juliaup].

## Running the integration tests

The integration tests make use of the [`dash.testing`][testing] module part of
the Python version of dash.

Instructions on how to install the required system dependencies can be found
in the [dash Contributor Guide][dash-cg].

Then,

```sh
cd Dash.jl
git clone --depth 1 https://github.com/plotly/dash.git -b dev dash-main
python3 -m venv venv
pip install --upgrade pip wheel
cd dash-main && pip install -e .[ci,dev,testing] && cd ..dash
pytest --headless --nopercyfinalize --percy-assets=test/assets/ test/integration/
```

Alternatively, one can run the integration tests using the same Docker
image as for our CircleCI test runs. See the [Docker image guide][docker-test]
for the details.

## Updating the resources

See the [Generate Dash.jl artifacts][resources].

## Updating the CircleCI Docker image

See the [Docker image guide][docker-update].

## Code Style

- indent with 4 spaces (no tabs),
- no whitespaces at EOLs,
- add a single newline at EOFs.

See the [`lint.yml` workflow][lint] for the details.

## Making a release

**Please follow the steps in order!** For example, running `git tag -a` before
`@JuliaRegistrator register` will lead to a failed release!

In the following steps, note that "X.Y.Z" refers to the new version we are
releasing.

### step 1

Make sure the [unit tests][jltest] and [CircleCI integration tests][circlecI]
are passing off the `dev` branch.

### step 2

Make a [PR][compare] with `master` as the _base_ branch and `dev` as _compare_ branch.

For consistency, name the PR: "Release X.Y.Z"

### step 3

Bump the `version` field in the `Project.toml` (following [semver][semver]) and then

```sh
git checkout dev
git pull origin dev
git commit -m "X.Y.Z"
git push
```

**N.B.** use `X.Y.Z` not `vX.Y.Z` in the commit message, the leading `v` is
reserved for git tags.

### step 4

Wait for approval and then merge the PR onto `master`.

### step 5

Navigate on GitHub to the merge commit from the `master` branch e.g. this
[one][ex-commit] and then add the following comment:

```sh
@JuliaRegistrator register branch=master
```

which tells the [Julia Registrator][registrator] to create a PR to the
[General Registry][jgr] e.g. this [one][ex-jgr-pr].

### step 6

Wait for the Julia Registry PR to be merged. If things go well, this should be
automatic!

### step 7

Off `master`, create and push a new git tag with:

```sh
git checkout master
git tag -a vX.Y.Z   # N.B. leading `v`
git push --tags
```

### step 8

Go the [release page][releases] and create a new release,
name it "Version X.Y.Z" for consistency and fill out sections:

- (usually) _Added_, _Changed_, _Fixed_ while including links to the PRs merged since the last release
- _New Contributor_, which should include mentions for all the first-time contributors

finally, place a [GitHub compare link][compare] between the last release and X.Y.Z
e.g. this [one][ex-diff].

### step 9

you are done :tada:

[jgr]: https://github.com/JuliaRegistries/General
[juliaup]: https://github.com/JuliaLang/juliaup
[testing]: https://dash.plotly.com/testing#end-to-end-tests
[dash-cg]: https://github.com/plotly/dash/blob/dev/CONTRIBUTING.md#tests
[resources]: ./gen_resources/README.md
[docker-test]: ./build/README.md#local-usage
[docker-update]: ./build/README.md#how-to-update-the-docker-image
[lint]: ./.github/workflows/lint.yml
[jltest]: https://github.com/plotly/Dash.jl/actions/workflows/jl_test.yml?query=branch%3Adev
[circlecI]: https://app.circleci.com/pipelines/github/plotly/Dash.jl?branch=dev
[semver]: https://pkgdocs.julialang.org/v1/toml-files/#The-version-field
[registrator]: https://github.com/JuliaRegistries/Registrator.jl
[releases]: https://github.com/plotly/Dash.jl/releases
[compare]: https://github.com/plotly/Dash.jl/compare/
[ex-commit]: https://github.com/plotly/Dash.jl/commit/5ec76d9d3360f370097937efd06e5de5a6025888
[ex-jgr-pr]: https://github.com/JuliaRegistries/General/pull/77586
[ex-diff]: https://github.com/plotly/Dash.jl/compare/v1.1.2...v1.2.0
