using Dash
using DashHtmlComponents
using DashCoreComponents

test_cases = Dict(
    "not-boolean" => Dict(
        "fail"=> true,
        "name"=> "simple \"not a boolean\" check",
        "component"=> dcc_input,
        "props"=> (debounce = 0,),
    ),
    "missing-required-nested-prop"=> Dict(
        "fail"=> true,
        "name"=> "missing required \"value\" inside options",
        "component"=> dcc_checklist,
        "props"=> (options = [Dict("label" => "hello")], value = ["test"]),
    ),
    "invalid-nested-prop"=> Dict(
        "fail"=> true,
        "name"=> "invalid nested prop",
        "component"=> dcc_checklist,
        "props"=> (options = [Dict("label"=> "hello", "value"=> true)], value = ["test"]),
    ),
    "invalid-arrayOf"=> Dict(
        "fail"=> true,
        "name"=> "invalid arrayOf",
        "component"=> dcc_checklist,
        "props"=> (options = "test", value = []),
    ),
    "invalid-oneOf"=> Dict(
        "fail"=> true,
        "name"=> "invalid oneOf",
        "component"=> dcc_input,
        "props"=> (type = "test",),
    ),
    "invalid-oneOfType"=> Dict(
        "fail"=> true,
        "name"=> "invalid oneOfType",
        "component"=> dcc_input,
        "props"=> (max = true,),
    ),
    "invalid-shape-5"=> Dict(
        "fail"=> true,
        "name"=> "invalid not required key",
        "component"=> dcc_dropdown,
        "props"=> (options = [Dict("label"=> "new york", "value"=> "ny", "typo"=> "asdf")],),
    ),
    "string-not-list"=> Dict(
        "fail"=> true,
        "name"=> "string-not-a-list",
        "component"=> dcc_checklist,
        "props"=> (options = [Dict("label"=> "hello", "value"=> "test")], value = "test"),
    ),
    "no-properties"=> Dict(
        "fail"=> false,
        "name"=> "no properties",
        "component"=> dcc_input,
        "props"=> (),
    ),
    "nested-children"=> Dict(
        "fail"=> true,
        "name"=> "nested children",
        "component"=> html_div,
        "props"=> (children = [[1]],),
    ),
    "deeply-nested-children"=> Dict(
        "fail"=> true,
        "name"=> "deeply nested children",
        "component"=> html_div,
        "props"=> (children = html_div([html_div([3, html_div([[10]])])]),),
    ),
    "dict"=> Dict(
        "fail"=> true,
        "name"=> "returning a dictionary",
        "component"=> html_div,
        "props"=> (children = Dict("hello" => "world"),),
    ),
    "allow-null-2"=> Dict(
        "fail"=> false,
        "name"=> "allow null as value",
        "component"=> dcc_dropdown,
        "props"=> (value = nothing,),
    ),
    "allow-null-3"=> Dict(
        "fail"=> false,
        "name"=> "allow null in properties",
        "component"=> dcc_input,
        "props"=> (value = nothing,),
    ),
    "allow-null-4"=> Dict(
        "fail"=> false,
        "name"=> "allow null in oneOfType",
        "component"=> dcc_store,
        "props"=> (id = "store", data = nothing),
    ),
    "long-property-string"=> Dict(
        "fail"=> false,
        "name"=> "long property string with id",
        "component"=> html_div,
        "props"=> (id = "pink div", style = repeat("color=> hotpink; ", 1000)),
    ),
    "multiple-wrong-values"=> Dict(
        "fail"=> true,
        "name"=> "multiple wrong props",
        "component"=> dcc_dropdown,
        "props"=> (id = "dropdown", value = 10, options = "asdf"),
    ),
    "boolean-html-properties"=> Dict(
        "fail"=> true,
        "name"=> "dont allow booleans for dom props",
        "component"=> html_div,
        "props"=> (contentEditable = true,),
    ),
    "allow-exact-with-optional-and-required-1"=> Dict(
        "fail"=> false,
        "name"=> "allow exact with optional and required keys",
        "component"=> dcc_dropdown,
        "props"=> (options = [Dict("label"=> "new york", "value"=> "ny", "disabled"=> false)],),
    ),
    "allow-exact-with-optional-and-required-2"=> Dict(
        "fail"=> false,
        "name"=> "allow exact with optional and required keys 2",
        "component"=> dcc_dropdown,
        "props"=> (options = [Dict("label"=> "new york", "value"=> "ny")],),
    )
)
app = dash()

app.layout = html_div() do
    html_div(id="content"),
    dcc_location(id="location")
end

callback!(app, callid"location.pathname => content.children") do pathname
    if isnothing(pathname) || pathname == "/"
        return "Initial state"
    end
    test_case = test_cases[strip(pathname, '/')]
    return html_div(
        id="new-component", children=test_case["component"](;test_case["props"]...)
    )
end

run_server(app, debug = true, dev_tools_hot_reload = false)