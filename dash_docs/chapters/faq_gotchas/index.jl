module chapters_faq_gotchas

using Dash, DashHtmlComponents, DashCoreComponents

app =  dash()

app.layout = html_div() do
    html_h1("Interactive Visualizations"),
    html_blockquote(dcc_markdown("This is the 6th and final chapter of the [Dash Tutorial](/).
    The [previous chapter](/sharing-data-between-callbacks) covered basic callback usage and the [next chapter](/state)
    describes how to share data between callbacks. The [rest of the Dash documentation](/) covers other
    topics like multi-page apps and component libraries.
    Just getting started? Make sure to [install the necessary
    dependencies](/installation)")),
    dcc_markdown("
    ### Frequently Asked Questions

    Q: How can I customize the appearance of my Dash app?
    A: Dash apps are rendered in the browser as modern standards-compliiant web apps. This means
    you can use CSS to style your Dash app as you would standard HTML.

    All `DashHtmlComponents` support inline CSS styling through a `style` attribute. An external
    CSS stylesheet can also be used to style `DashHtmlComponents` and `DashCoreComponents` by
    targeting the IDs or classnames of your components. Both `DashHtmlComponents` and `DashCoreComponents`
    accept the attribute `className`, which corresponds to the HTML element attribute `class`.

    To use an external stylesheet, simply declare the `external_stylesheets` attribute when initializing your Dash app:

    `app = dash(external_stylesheets=[\"URL TO YOUR STYLESHEET\"])`
    "),
    html_hr(),
    dcc_markdown("

    Q: How can I add JavaScript to my Dash app?
    A: To use an external script, simply declare the `external_scripts` attribute when initializing your Dash app:

    `app = dash(external_scripts=[\"URL TO YOUR SCRIPT\"])`

    ### Gotchas

    There are some aspects of how Dash works that can be counter-intuitive. This
    can be especially true of how the callback system works. This section outlines
    some common Dash gotchas that you might encounter as you start building out more
    complex Dash apps. If you have read through the rest of [Dash Tutorial](/) and are
    encountering unexpected behavior, this is a good section to read through. If you still have
    residual questions, the [Dash Community forums](https://community.plotly.com/c/dash/julia/20)
    is a good place to ask them.

    #### Callbacks require their `inputs`, `states`, and `output` to be present in the layout

    By default, Dash applies validation to your callbacks, which performs checks such as
    validating the types of callback arguments and checking to see whether the specified `input`
    and `output` components actually have the specified properties. For full validation, all components
    withiin your callback must thererfore appear in the initial layout of your app, and you will see an
    error if they do not.

    However, in the case of more complex Dash apps that involve dynamic modification of the layout
    (such as multipage apps), not every component appearing in your callbacks will be included in the
    initial layout. You can remove this restrictioin by disabling callback validation like this:

    `app = dash(suppress_callback_exceptions = true)`

    #### Callbacks require *all* `inputs`, `states`, and `output` to be rendered on the page

    If you have disabled callback validation in order to support dynamic layouts, then you won't be
    automatically alerted to the situation where a component within a callback is not found within a
    layout. In this situation, where a component registered with a callback is missing from the layout,
    the callback will fail to fire. For example, if you define a callback with only a subset of the
    specified `inputs` present in the current page layout, the callback will simply not fire at all.

    #### A component/property pair can only be the `output` of one callback

    For a given component/property pair, (eg `my-graph`, `figure`), it can only be registered as the
    `output` of one callback. If you want to associate two logically separate sets of `inputs` with
    the one output component/property pair, you'll have to bundle them up into a larger callback and
    detect which of the relevant `inputs` triggered the callback inside the function. For `html_button`
    elements, detecting which one triggered the callback can be done using the `n_clicks_timestamp` property.

    ### All callbacks must be defined before the server starts

    All your callbacks must be defined before your Dash app's server starts running, which is to say, before
    you call `run_server(app)`. This means that while you can assemble changed layout fragments dynamically
    during the handling of a callback, you can't define dynamic callbacks in response to the user input during
    the handling of a callback. If you have a dynamic interface, where a callback changes the layout to include
    a different set of input controls, then you must have already defined the callbacks required to service these
    new controls in advance.

    For example, a common scenario is a `dcc_dropdown` component that udpdates the current
    layout to replace a dashboard with another logically distinct dashboard that has a different set
    of controls (the number and type of which might depend on other user input) and different logic
    for generating the underlying data. A sensible organization would be for each of these dashboards
    to have separate callbacks. In this scenario, each of these callbacks must then be defined before the app starts running.

    Generally speaking, if a feature of your Dash app is that the number of `inputs` or `states` is determined
    by a user's input, then you must pre-define up front every permutation of callback that a user can potentially
    trigger.
    "),
    html_hr(),
    dcc_markdown("[Back to the table of contents](/)")
end

end
