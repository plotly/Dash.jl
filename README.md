[![CircleCI](https://circleci.com/gh/plotly/Dash.jl/tree/master.svg?style=svg)](https://circleci.com/gh/plotly/Dash.jl/tree/master)
[![GitHub](https://img.shields.io/github/license/plotly/dashR.svg?color=dark-green)](https://github.com/plotly/Dash.jl/blob/master/LICENSE)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/plotly/Dash.jl.svg?color=dark-green)](https://github.com/plotly/Dash.jl/graphs/contributors)

# Dash for Julia

## Project Status

The core Dash component libraries have been submitted to the Julia package registry; upon their acceptance, `Dash.jl` will be submitted. The initial release of `Dash.jl` is anticipated in September 2020. A Julia version of the Dash Tutorial is currently in preparation, and will be available online soon. As of v1.15.0 of Dash, Julia components can be generated in tandem with Python and R components. Interested in getting involved with the project? Sponsorship is a great way to accelerate the progress of open source projects like this one; please feel free to [reach out to us](https://plotly.com/consulting-and-oem/)!

#### Create beautiful, analytic applications in Julia.

🚧 Dash.jl is a work-in-progress. Feel free to test the waters and submit issues.

Built on top of Plotly.js, React and HTTP.jl, [Dash](https://plotly.com/dash/) ties modern UI elements like dropdowns, sliders, and graphs directly to your analytical Julia code.

## Installation

Please ensure that you are using a version of Julia >= 1.2.

To install the most recently released version:

```julia
using Pkg; Pkg.add(PackageSpec(url="https://github.com/plotly/Dash.jl.git"))
```

To install the latest (stable) development version instead:

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/plotly/DashBase.jl.git"))
Pkg.add(PackageSpec(url="https://github.com/plotly/dash-html-components.git", rev="master"))
Pkg.add(PackageSpec(url="https://github.com/plotly/dash-core-components.git", rev="master"))
Pkg.add(PackageSpec(url="https://github.com/plotly/dash-table.git", rev="master"))
Pkg.add(PackageSpec(url="https://github.com/plotly/Dash.jl.git", rev="dev"))
```

## Usage

### Basic application

```jldoctest
julia> using Dash
julia> using DashHtmlComponents
julia> using DashCoreComponents

julia> app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

julia> app.layout = html_div() do
        html_h1("Hello Dash"),
        html_div("Dash.jl: Julia interface for Dash"),
        dcc_graph(
            id = "example-graph",
            figure = (
                data = [
                    (x = [1, 2, 3], y = [4, 1, 2], type = "bar", name = "SF"),
                    (x = [1, 2, 3], y = [2, 4, 5], type = "bar", name = "Montréal"),
                ],
                layout = (title = "Dash Data Visualization",)
            )
        )
    end

julia> run_server(app, "0.0.0.0", 8080)
```

* The `DashApp` struct represents a dashboard application.
* To make `DashApp` struct use `dash(layout_maker::Function, name::String;  external_stylesheets::Vector{String} = Vector{String}(), url_base_pathname="/", assets_folder::String = "assets")` where `layout_maker` is a function with signature ()::Component
* Unlike the Python version where each Dash component is represented as a separate class, all components in Dash.jl are represented by struct `Component`.
* You can create `Component` specific for concrete Dash component by the set of functions in the form ``lowercase(<component package>)_lowercase(<component name>)``. For example, in Python html `<div>` element is represented as `HTML.Div` in Dash.jl it is created using function `html_div`
* The list of all supported components is available in docstring for Dash.jl module.
* All functions for a component creation have the signature `(;kwargs...)::Component`. List of key arguments specific for the concrete component is available in the docstring for each function.
* Functions for creation components which have `children` property have two additional methods ``(children::Any; kwargs...)::Component`` and ``(children_maker::Function; kwargs..)::Component``. `children` must by string or number or single component or collection of components.
* ``make_handler(app::Dash; debug::Bool = false)`` makes a handler function for using in HTTP package.

__Once you have run the code to create the Dashboard, go to `http://127.0.0.1:8080` in your browser to view the Dashboard!__

### Basic Callback

```jldoctest

julia> using Dash
julia> using DashHtmlComponents
julia> using DashCoreComponents

julia> app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

julia> app.layout = html_div() do
        dcc_input(id = "my-id", value="initial value", type = "text"),
        html_div(id = "my-div")
    end

julia> callback!(app, Output("my-div", "children"), Input("my-id", "value")) do input_value
    "You've entered $(input_value)"
end

julia> run_server(app, "0.0.0.0", 8080)
```

* You can make your dashboard interactive by register callbacks for changes in frontend with function ``callback!(func::Function, app::Dash, output, input, state)``
* Inputs and outputs (and states, see below) of callback can be `Input`, `Output`, `State` objects or vectors of this objects
* Callback function must have the signature(inputs..., states...), and provide a return value comparable (in terms of number of elements) to the outputs being updated.

### States and Multiple Outputs

```jldoctest
julia> using Dash
julia> using DashHtmlComponents
julia> using DashCoreComponents

julia> app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

julia> app.layout = html_div() do
        dcc_input(id = "my-id", value="initial value", type = "text"),
        html_div(id = "my-div"),
        html_div(id = "my-div2")
    end

julia> callback!(app, [Output("my-div","children"), Output("my-div2","children")], Input("my-id", "value"), State("my-id", "type")) do input_value, state_value
    "You've entered $(input_value) in input with type $(state_value)",
    "You've entered $(input_value)"
end
julia> run_server(app, "0.0.0.0", 8080)
```

## Comparison with original Python syntax

### component naming:

`html.Div` => `html_div`, `dcc.Graph` => `dcc_graph` and etc

### component creation:

Just as in Python, functions for declaring components have keyword arguments, which are the same as in Python. ``html_div(id="my-id", children="Simple text")``.
For components which declare `children`, two additional signatures are available. ``(children; kwargs..)`` and ``(children_maker::Function; kwargs...)`` so one can write ``html_div("Simple text", id="my-id")`` for simple elements, or choose an abbreviated syntax with `do` syntax for complex elements:

```julia
html_div(id="outer-div") do
    html_h1("Welcome"),
    html_div(id="inner-div") do
    ......
    end
end
```

### application and layout:

* python:

```python
app = dash.Dash("Test", external_stylesheets=external_stylesheets)
app.layout = html.Div(children=[....])
```

* Dash.jl:

```julia
app = dash("Test", external_stylesheets=external_stylesheets)

app.layout = html_div() do
    ......
   end
```

### callbacks:

* Python:

```python
@app.callback(Output('output', 'children'),
              [Input('submit-button', 'n_clicks')],
              [State('state-1', 'value'),
               State('state-2', 'value')])
def update_output(n_clicks, state1, state2):
.....

```

* Dash.jl:

```julia
callback!(app, Output("output", "children"),
              [Input("submit-button", "n_clicks")],
              [State("state-1", "value"),
               State("state-2", "value")]) do  n_clicks, state1, state2
.....
end
```

Be careful - in Dash.jl states come first in an arguments list.

### JSON:

I use JSON2.jl for JSON serialization/deserialization, so in callbacks all JSON objects are `NamedTuples` rather than dictionaries. Within component properties you can use both `Dict` and `NamedTuple` for JSON objects.

Note when declaring elements with a single properly that `layout = (title = "Test graph")` is not interpreted as a `NamedTuple` by Julia  - you'll need to add a comma when declaring the layout, e.g. `layout = (title = "Test graph",)`
