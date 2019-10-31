# Dashboards

Julia backend for [Plotly Dash](https://github.com/plotly/dash)
It is in its early development phase so any bugs may arise, please report me about issues

## Instalation

```julia
import Pkg; Pkg.add("https://github.com/waralex/Dashboards.git")
```

## Usage

### Basic application

```jldoctest
julia> import HTTP
julia> using Dashboards
julia> app = Dash("Test app", external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]) do
    html_div() do
        html_h1("Hello Dashboards"),
        html_div("Dashboards: Julia interface for Dash"),
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
end
julia> handler = make_handler(app, debug = true)
julia> HTTP.serve(handler, HTTP.Sockets.localhost, 8080)
```
* The `Dash` struct represent dashboard application.
* The constructor for `Dash` struct is `Dash(layout_maker::Function, name::String;  external_stylesheets ::Vector{String} = Vector{String}(), url_base_pathname="/")` where `layout_maker` is a function with signature ()::Component
* Unlike the python version where each Dash component is represented as a separate class, all components in Dashboard is represented by struct `Component`. 
* You can create `Component` specific for concrete Dash component by the set of functions in the form `lowercase(<component package>)_lowercase(<component name>)`. For example, in python html `<div>` element is represented as `HTML.Div` in Dasboards it created using function `html_div`
* List of all supported components is available in docstring for Dasboards module
* All functions for a component creation has the signature `(;kwargs...)::Component`. List of key arguments specific for the concrete component is available in the docstring for each function
* Functions for creation components which has `children` property has two additional methods `(children::Any; kwargs...)::Component` and `(children_maker::Function; kwargs..)::Component`. `children` must by string or number or single component or collection of components
* `make_handler(app::Dash; debug::Bool = false)` makes handler function for using in HTTP package

### Basic Callback
```jldoctest
julia> import HTTP
julia> using Dashboards
julia> app = Dash("Test app", external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]) do
    html_div() do
        dcc_input(id = "my-id", value="initial value", type = "text"),
        html_div(id = "my-div")        
    end
end
julia> callback!(app, callid"my-id.value => my-div.children") do input_value
    "You've entered $(input_value)"
end
julia> handler = make_handler(app, debug = true)
julia> HTTP.serve(handler, HTTP.Sockets.localhost, 8080)
```
* You can make your dashboard interactive by register callbacks for changes in frontend with function `callback!(func::Function, app::Dash, id::CallbackId)`
* Inputs and outputs (and states, see below) of callback are described by struct `CallbackId` which can easily created by string macro `callid""`
* `callid""` parse string in form "[{state1 [,...]}] input1[,...] => output1[,...]" where all items is "<element id>.<property name>"
* Callback function must have the signature(states..., inputs...) and return data for output
* Be careful, checks for the identifier and properties have not yet been implemented, so errors in determining callid can lead to errors during request processing

### States and Multiple Outputs
```jldoctest
julia> import HTTP
julia> using Dashboards
julia> app = Dash("Test app", external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]) do
    html_div() do
        dcc_input(id = "my-id", value="initial value", type = "text"),
        html_div(id = "my-div"),
        html_div(id = "my-div2")        
    end
end
julia> callback!(app, callid"{my-id.type} my-id.value => my-div.children, my-div2.children") do state_value, input_value
    "You've entered $(input_value) in input with type $(state_value)",
    "You've entered $(input_value)"
end
julia> handler = make_handler(app, debug = true)
julia> HTTP.serve(handler, HTTP.Sockets.localhost, 8080)
```
* For multiple output callback must return any collection with element for each output