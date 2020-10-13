library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  graph.update=utils$LoadExampleCode('dash_docs/chapters/clientside_callbacks/examples/graph_update_fe_be.R')
)

layout <- htmlDiv(
  list(
    htmlH1("Callback Gotchas"),
    dccMarkdown("
There are some aspects of how Dash works that can be counter-intuitive. This
can be especially true of how the callback system works. This section
outlines some common Dash gotchas that you might encounter as you start
building out more complex Dash apps. If you have read through the rest of
the <dccLink children='Dash Tutorial' href='/'/> and are encountering unexpected behaviour, this is a
good section to read through. If you still have residual questions, the
[Dash Community forums](https://community.plotly.com/c/dash) is a great place
to ask them.


### Callbacks require their `Inputs`, `States`, and `Output` to be present in the layout

By default, Dash applies validation to your callbacks, which performs checks
such as validating the types of callback arguments and checking to see
whether the specified `Input` and `Output` components actually have the
specified properties. For full validation, all components within your
callback must therefore appear in the initial layout of your app, and you
will see an error if they do not.

However, in the case of more complex Dash apps that involve dynamic
modification of the layout (such as multi-page apps), not every component
appearing in your callbacks will be included in the initial layout. You can
remove this restriction by disabling callback validation like this:

```r
app$config$silence_routes_logging = TRUE
```

### Callbacks require *all* `Inputs` and `States` to be rendered on the page

If you have disabled callback validation in order to support dynamic
layouts, then you won't be automatically alerted to the situation where a
component within a callback is not found within a layout. In this situation,
where a component registered with a callback is missing from the layout, the
callback will fail to fire. For example, if you define a callback with only
a subset of the specified `Inputs` present in the current page layout, the
callback will simply not fire at all.


### A component/property pair can only be the `Output` of one callback

For a given component/property pair (eg `'my-graph'`, `'figure'`), it can
only be registered as the `Output` of one callback. If you want to associate
two logically separate sets of `Inputs` with the one output
component/property pair, you’ll have to bundle them up into a larger
callback and detect which of the relevant `Inputs` triggered the callback
inside the function. For `html.Button` elements, detecting which one
triggered the callback ca be done using `callback_context` or the legacy
`n_clicks_timestamp` property. For an example of this, see the question in the 
FAQ, *How do I determine which `Input` has changed?*.


### All callbacks must be defined before the server starts

All your callbacks must be defined before your Dash app's server starts
running, which is to say, before you call `app.run_server(debug=True)`. This means
that while you can assemble changed layout fragments dynamically during the
handling of a callback, you can't define dynamic callbacks in response to
user input during the handling of a callback. If you have a dynamic
interface, where a callback changes the layout to include a different set of
input controls, then you must have already defined the callbacks required to
service these new controls in advance.

For example, a common scenario is a `Dropdown` component that updates the
current layout to replace a dashboard with another logically distinct
dashboard that has a different set of controls (the number and type of which
might which might depend on other user input) and different logic for
generating the underlying data. A sensible organisation would be for each of
these dashboards to have separate callbacks. In this scenario, each of these
callbacks much then be defined before the app starts running.

Generally speaking, if a feature of your Dash app is that the number of
`Inputs` or `States` is determined by a user's input, then you must
pre-define up front every permutation of callback that a user can
potentially trigger. For an example of how this can be done programmatically
using the `callback` decorator, see this [Dash Community forum
post](https://community.plotly.com/t/callback-for-dynamically-created-graph/5511).
''')
  "),

htmlHr(),
dccMarkdown("
[Back to the Table of Contents](/)
                ")
  )
)
