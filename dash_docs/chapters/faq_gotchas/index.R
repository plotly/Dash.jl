library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
 last_clicked_button=utils$LoadExampleCode('dash_docs/chapters/faq_gotchas/examples/last_clicked_button.R')
)


layout <- htmlDiv(list(
  dccMarkdown("
# FAQs and Gotchas

> This is the *6th* and final chapter of the essential [Dash Tutorial](/).
> The [previous chapter](/sharing-data-between-callbacks) described how to
> share data between callbacks. The [rest of the Dash documentation](/)
> covers other topics like multi-page apps and component libraries.


## Frequently Asked Questions

**Q:** *How can I customize the appearance of my Dash app?*

**A:** Dash apps are rendered in the browser as modern standards compliant
web apps. This means that you can use CSS to style your Dash app as you
would standard HTML.

All `dashHtmlComponents` support inline CSS styling through a `style`
attribute. An external CSS stylesheet can also be used to style
`dashHtmlComponents` and `dashCoreComponents` by targeting the ID or
class names of your components. Both `dashHtmlComponents` and
`dashCoreComponents` accept the attribute `className`, which corresponds
to the HTML element attribute `class`.

The [Dash HTML Components](/dashHtmlComponents) section in the Dash User
Guide explains how to supply `dashHtmlComponents` with both inline
styles and CSS class names that you can target with CSS style sheets. The
[Adding CSS & JS and Overriding the Page-Load
Template](/external-resources) section in the Dash Guide explains how you
can link your own style sheets to Dash apps.

------------------------

**Q:** *How can I add JavaScript to my Dash app?*

**A:** You can add your own scripts to your Dash app, just like you would
add a JavaScript file to an HTML document. See the [Adding CSS & JS and
Overriding the Page-Load Template](/external-resources) section in the
Dash Guide.

------------------------

**Q:** *Can I make a Dash app with multiple pages?*

**A:** Yes! Dash has support for multi-page apps. See the [Multi-Page Apps
and URL Support](/urls) section in the Dash User Guide.

------------------------

**Q:** *How I can I organise my Dash app into multiple files?*

**A:** A strategy for doing this can be found in the [Multi-Page Apps
and URL Support](/urls) section in the Dash User Guide.

------------------------

**Q:** *How do I determine which `input` has changed?*

**A:** In addition to event properties like `n_clicks` that change whenever 
an event happens (in this case a click), there is a global variable 
`app$callback_context()`, available only inside a callback. It has properties:

  - `triggered`:  list of changed properties. 
This will be empty on initial load, unless an `input` prop got its value from 
another initial callback. 
After a user action it is a length-1 list, 
unless two properties of a single component update simultaneously, 
such as a value and a timestamp or event counter.

   - `inputs` and `states`: allow you to access the callback params by id and prop instead of through the function args. 
These have the form of dictionarie `app$callback_context()$triggered$value`

Here's an example of how this can be done:
  "),
  examples$last_clicked_button$source,
  examples$last_clicked_button$layout,
 
  dccMarkdown("
**Note:** Prior to the addition of `callback_context`, you needed to compare timestamp properties 
like `n_clicks_timestamp` to find the most recent click. 
While existing uses of `*_timestamp` continue to work for now, this approach is deprecated, 
and may be removed in a future update. The one exception is `modified_timestamp` from `dccStore`, 
which is safe to use, it is NOT deprecated.

------------------------

**Q:** *Can I use jQuery with Dash?*

**A:** For the most part, you can't. Dash uses React to render your app on
the client browser. React is fundamentally different to jQuery in that it
makes use of a virtual DOM (Document Object Model) to manage page
rendering. Since jQuery doesn't speak React's virtual DOM, you can't use
any of jQuery's DOM manipulation facilities to change the page layout,
which is frequently why one might want to use jQuery. You can however use
parts of jQuery's functionality that do not touch the DOM, such as
registering event listeners to cause a page redirect on a keystroke.

In general, if you are looking to add custom clientside behavior in your
application, we recommend encapsulating that behavior in a [custom Dash
component](https://dash.plotly.com/plugins).

------------------------

**Q:** *I have more questions! Where can I go to ask them?*

**A:** The [Dash Community forums](https://community.plotly.com/c/dash) is full
of people discussing Dash topics, helping each other with questions, and
sharing Dash creations. Jump on over and join the discussion.


## Gotchas

There are some aspects of how Dash works that can be counter-intuitive. This
can be especially true of how the callback system works. This section
outlines some common Dash gotchas that you might encounter as you start
building out more complex Dash apps. If you have read through the rest of
the [Dash Tutorial](/) and are encountering unexpected behaviour, this is a
good section to read through. If you still have residual questions, the
[Dash Community forums](https://community.plotly.com/c/dash) is a great place
to ask them.

### Callbacks require their `inputs`, `states`, and `output` to be present in the layout

By default, Dash applies validation to your callbacks, which performs checks
such as validating the types of callback arguments and checking to see
whether the specified `input` and `output` components actually have the
specified properties. For full validation, all components within your
callback must therefore appear in the initial layout of your app, and you
will see an error if they do not.

However, in the case of more complex Dash apps that involve dynamic
modification of the layout (such as multi-page apps), not every component
appearing in your callbacks will be included in the initial layout. You can
remove this restriction by disabling callback validation like this:

`Dash$new(suppress_callback_exceptions = TRUE)`


### Callbacks require *all* `inputs`, `states`, and `output` to be rendered on the page

If you have disabled callback validation in order to support dynamic
layouts, then you won't be automatically alerted to the situation where a
component within a callback is not found within a layout. In this situation,
where a component registered with a callback is missing from the layout, the
callback will fail to fire. For example, if you define a callback with only
a subset of the specified `inputs` present in the current page layout, the
callback will simply not fire at all.


### Callbacks can only target a single `output` component/property pair

Currently, for a given callback, it can only have a single `output`, which
targets one component/property pair eg `'my-graph'`, `'figure'`. If you
wanted, say, four `Graph` components to be updated based on a particular
user input, you either need to create four separate callbacks which each
target an individual `Graph`, or have the callback return a `htmlDiv`
container that holds the updated four Graphs.

There are plans to remove this limitation. You can track the status of this
in this [GitHub Issue](https://github.com/plotly/dash/issues/149).


### A component/property pair can only be the `output` of one callback

For a given component/property pair (eg `'my-graph'`, `'figure'`), it can
only be registered as the `output` of one callback. If you want to associate
two logically separate sets of `inputs` with the one output
component/property pair, you'll have to bundle them up into a larger
callback and detect which of the relevant `inputs` triggered the callback
inside the function. For `htmlButton` elements, detecting which one
triggered the callback can be done using the `n_clicks_timestamp`
property. For an example of this, see the question in the FAQ, *How do I
determine which `input` has changed?*.


### All callbacks must be defined before the server starts

All your callbacks must be defined before your Dash app's server starts
running, which is to say, before you call `app$run_server(debug=TRUE)`. This means
that while you can assemble changed layout fragments dynamically during the
handling of a callback, you can't define dynamic callbacks in response to
user input during the handling of a callback. If you have a dynamic
interface, where a callback changes the layout to include a different set of
input controls, then you must have already defined the callbacks required to
service these new controls in advance.

For example, a common scenario is a `dccDropdown` component that updates the
current layout to replace a dashboard with another logically distinct
dashboard that has a different set of controls (the number and type of which
might which might depend on other user input) and different logic for
generating the underlying data. A sensible organisation would be for each of
these dashboards to have separate callbacks. In this scenario, each of these
callbacks much then be defined before the app starts running.

Generally speaking, if a feature of your Dash app is that the number of
`inputs` or `states` is determined by a user's input, then you must
pre-define up front every permutation of callback that a user can
potentially trigger. For an example of how this can be done programmatically
using the `callback` handler, see this [Dash Community forum
post](https://community.plotly.com/t/callback-for-dynamically-created-graph/5511).

  "),
  htmlHr(),
  dccMarkdown("
[Back to the Table of Contents](/)
              ")
))
