# Generate Dash.jl artifacts

Dash.jl uses Julia
[Artifacts](https://docs.julialang.org/en/v1/stdlib/Artifacts/) to load
front-end resources that Dash.jl shares with the python version of
[dash](https://github.com/plotly/dash).

The [Artifacts.toml](../Artifacts.toml) file lists the location of the
publicly-available tarball containing all the required resources.

The tarballs are hosted on the
[DashCoreResources](https://github.com/plotly/DashCoreResources) repo, under
_Releases_. They are generated and deployed using the `generate.jl` script in
this directory.

## How to run `generate.jl` ?

### Step 0: get push rights to `DashCoreResources`

### Step 1: get GitHub personal access token

See [GitHub docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)
for more info.

If using a fine-grained token, make sure to enable _Read and Write access to code_.

### Step 2: expose your token into your shell

```sh
# for example:
export GITHUB_TOKEN="<your GitHub personal access token>"
```

### Step 3: run `generate.jl`

```sh
cd Dash.jl/gen_resources

# install `generate.jl` deps
julia --project -e 'import Pkg; Pkg.instantiate()'

# generate `gen_resources/build/deploy/` content,
# but do not deploy!
julia --project generate.jl

# if everything looks fine,
# generate `gen_resources/build/deploy/` content (again) and
# deploy to the `DashCoreResource` releases with:
julia --project generate.jl --deploy
```

#### If `generate.jl` errors

<details>
<summary>with a PyError / PyImport error</summary>

that is an error like:

```sh
ERROR: LoadError: PyError (PyImport_ImportModule

The Python package dash could not be imported by pyimport. Usually this means
that you did not install dash in the Python version being used by PyCall.

PyCall is currently configured to use the Python version at:

/usr/bin/python3
```

try

```jl
using PyCall
ENV["PYTHON"] = joinpath(homedir(), ".julia/conda/3/x86_64/bin")
import Pkg
Pkg.build("PyCall")
# check that it matches with
PyCall.pyprogramname
```

and then re-run `generate.jl`.

</details>

### Step 4: Commit the changes to `Artifacts.toml`

and push to [plotly/Dash.jl](https://github.com/plotly/Dash.jl)
(preferably on a new branch) to get a CI test run started.
