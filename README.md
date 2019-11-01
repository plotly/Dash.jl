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
* The constructor for `Dash` struct is ``Dash(layout_maker::Function, name::String;  external_stylesheets::Vector{String} = Vector{String}(), url_base_pathname="/", assets_folder::String = "assets")`` where `layout_maker` is a function with signature ()::Component
* Unlike the python version where each Dash component is represented as a separate class, all components in Dashboard are represented by struct `Component`. 
* You can create `Component` specific for concrete Dash component by the set of functions in the form ``lowercase(<component package>)_lowercase(<component name>)``. For example, in python html `<div>` element is represented as `HTML.Div` in Dasboards it is created using function `html_div`
* The list of all supported components is available in docstring for Dasboards module
* All functions for a component creation have the signature `(;kwargs...)::Component`. List of key arguments specific for the concrete component is available in the docstring for each function
* Functions for creation components which have `children` property have two additional methods ``(children::Any; kwargs...)::Component`` and ``(children_maker::Function; kwargs..)::Component``. `children` must by string or number or single component or collection of components
* ``make_handler(app::Dash; debug::Bool = false)`` makes handler function for using in HTTP package

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
* You can make your dashboard interactive by register callbacks for changes in frontend with function ``callback!(func::Function, app::Dash, id::CallbackId)``
* Inputs and outputs (and states, see below) of callback are described by struct `CallbackId` which can easily created by string macro `callid""`
* `callid""` parse string in form ``"[{state1 [,...]}] input1[,...] => output1[,...]"`` where all items is ``"<element id>.<property name>"``
* Callback function must have the signature(states..., inputs...) and return data for output

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

## Comparation with original python syntax

### component naming:

`html.Div` => `html_div`, `dcc.Graph` => `dcc_graph` and etc

### component creation:

Just like in Python, functions for creating components have keywords arguments, which are the same as in Python. ``html_div(id="my-id", children="Simple text")``. 
For components that have `children` prop, two additional signatures are available. ``(children; kwargs..)`` and ``(children_maker::Function; kwargs...)`` so You can write ``html_div("Simple text", id="my-id")``  for simple elements or avoid the hell of nested brackets with `do` syntax for complex elements:

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

* Dashboards:
```julia
app = Dash("Test", external_stylesheets=external_stylesheets) do
   html_div() do
    ......
   end
end
```
### callbacks:
* python:
```python
@app.callback(Output('output', 'children'),
              [Input('submit-button', 'n_clicks')],
              [State('state-1', 'value'),
               State('state-2', 'value')])
def update_output(n_clicks, state1, state2):
.....

```
* Dashboards:
```julia
callback!(app, callid"""{state1.value, state2.value} 
                                   submit-button.n_clicks 
                                   => output.children""" ) do state1, state2, n_clicks
.....
end
```
Be careful - in Dashboards states came first in arguments list

### json:
I use JSON2 for json serialization/deserialization, so in callbacks all json objects are NamedTuples not Dicts. In component props you can use both Dicts and NamedTuples for json objects. But be careful with single property objects: `layout = (title = "Test graph")` is not interpreted as NamedTuple by Julia  - you need add comma at the end `layout = (title = "Test graph",)`