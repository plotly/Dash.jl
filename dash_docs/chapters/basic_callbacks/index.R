library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  simple_callbacks=utils$LoadExampleCode('dash_docs/chapters/basic_callbacks/examples/simple-callback.R'),
  simple_slider=utils$LoadExampleCode('dash_docs/chapters/basic_callbacks/examples/hello-slider.R'),
  multi_inputs=utils$LoadExampleCode('dash_docs/chapters/basic_callbacks/examples/multi-inputs.R'),
  multi_output=utils$LoadExampleCode('dash_docs/chapters/basic_callbacks/examples/multi-output.R'),
  multi_output2=utils$LoadExampleCode('dash_docs/chapters/basic_callbacks/examples/multi-output-v2.R'),
  basic_input=utils$LoadExampleCode('dash_docs/chapters/basic_callbacks/examples/basic-input.R'),
  basic_state=utils$LoadExampleCode('dash_docs/chapters/basic_callbacks/examples/basic-state.R')
)

layout <- htmlDiv(
  list(
    dccMarkdown("
# Basic Dash Callbacks
> This is the *3rd* chapter of the [Dash Tutorial](/).
> The [previous chapter](/getting-started) covered the Dash app `layout`
> and the [next chapter](/state) covers an additional concept of callbacks
> known as `state`.
> Just getting started? Make sure to [install the necessary dependencies](/installation).
  "),

    dccMarkdown("
In the [previous chapter on the app `layout`](/getting-started) we learned
that the `app$layout()` describes what the app looks like and is
a hierarchical tree of components.
The `dashHtmlComponents` package provides classes for all of the HTML
tags, and the keyword arguments describe the HTML attributes like `style`,
`className`, and `id`. The `dashCoreComponents` package
generates higher-level components like controls and graphs.

This chapter describes how to make your
Dash apps interactive.

Let's get started with a simple example.
  "),

    htmlH4("
      Dash App Layout
      ", id = 'dash-app-layout'),
    #
    # Example of basic callbacks
    # dccSyntaxHighlighter(
    #   examples$simple_callbacks$source_code,
    #   language='r',
    #   customStyle=styles.code_container
    # ),

    # htmlDiv(examples$simple_callbacks$layout,
    #          className="example-container"),
    #

    examples$simple_callbacks$source_code,
    examples$simple_callbacks$layout,

    dccMarkdown("
Try typing in the text box. The children property of the output component updates
right away. Let's break down what's happening here:

1.The \"inputs\" and \"outputs\" of our application interface are described
declaratively through the `app$callback` handler.

2.In Dash, the inputs and outputs of our application are simply the
properties of a particular component. In this example,
our input is the \"`value`\" property of the component that has the ID
\"`my-id`\". Our output is the \"`children`\" property of the
component with the ID \"`my-div`\".

3.Whenever an input property changes, the function that the
callback handler wraps will get called automatically.
Dash provides the function with the new value of the input property as
an input argument and Dash updates the property of the output component
with whatever was returned by the function.

4.The component `id` and component `property` keywords are optional
(there are only two arguments for each of those objects).
I have included them here for clarity but I will omit them from here on
out for brevity and readability.

5.Don't confuse the `dashR::input` object from the
`dashCoreComponents::dccInput` object. The former is just used in these
callbacks and the latter is an actual component.

6.Notice how we don't set a value for the `children` property of the
`my-div` component in the `layout`. When the Dash app starts, it
automatically calls all of the callbacks with the initial values of the
input components in order to populate the initial state of the output
components. In this example, if you specified something like
`htmlDiv(id='my-id-div', children='Hello world')`, it would get overwritten
when the app starts.

It's sort of like programming with Microsoft Excel:
whenever an input cell changes, all of the cells that depend on that cell
will get updated automatically. This is called \"Reactive Programming\".

Remember how every component was described entirely through it's set of
keyword arguments? Those properties are important now.
With Dash's interactivity, we can dynamically update any of those properties
through a callback function. Frequently we'll update the `children` of a
component to display new text or the `figure` of a `dccGraph` component
to display new data, but we could also update the `style` of a component or
even the available `options` of a `dccDropdown` component!

***

Let's take a look at another example where a `dccSlider` updates a
`dccGraph`.
  "),


    # Example of slicer
    examples$simple_slider$source_code,
    examples$simple_slider$layout,

    dccMarkdown("
In this example, the `value` property of the `dccSlider` is the input of the app
and the output of the app is the `figure` property of the `dccGraph`.
Whenever the `value` of the `dccSlider` changes, Dash calls the callback
function `update_figure` with the new value. The function filters the
dataframe with this new value, constructs a `figure` object,
and returns it to the Dash application.

There are a few nice patterns in this example:

1.We load our dataframe at the start of the app: `df <- read.csv('...')`.
This dataframe `df` is in the global state of the app and can be
read inside the callback functions.

2.Load data into memory can be expensive. By loading querying data at
the start of the app instead of inside the callback functions, we ensure
that this operation is only done when the app server starts. When a user
visits the app or interacts with the app, that data (`df`)
is already in memory.
If possible, expensive initialization (like downloading or querying data)
should be done in the global scope of the app instead of within the
callback functions.

3.The callback does not modify the original data, it just creates copies
of the dataframe.
This is important: *your callbacks should never mutate variables
outside of their scope*. If your callbacks modify global states, then one
user's session might affect the next user's session and when the app is
deployed on multiple processes or threads, those modifications will *not*
be shared across sessions.

#### Multiple inputs

In Dash, any `output` can have multiple `input` components.
Here's a simple example that binds five Inputs
(the `value` property of two `dccDropdown` components, two `dccRadioItems` components,
and one `dccSlider` component) to one output component
(the `figure` property of the `dccGraph` component).
Notice how the `app$callback` lists all five `input` inside
a list in the second argument.
"),

    # Example of mutli-inputs
    examples$multi_inputs$source_code,
    examples$multi_inputs$layout,

    dccMarkdown("
In this example, the `callback` function is activated whenever the
`value` property of the `dccDropdown`, `dccSlider`, or `dccRadioItems` components
change.

The input arguments are the new or current value of each of the `input` properties, in the order that they were
specified.

Even though only a single `input` changes at a time (a user can only change
the value of a single Dropdown in a given moment), Dash collects the current
state of all of the specified `input` properties and passes them into your
function for you. Your callback functions are always guaranteed to be passed
the representative state of the app.

Let's extend our example to include multiple outputs.

#### Multiple Outputs

So far all the callbacks we've written only update a single Output property. We
can also update several at once: put all the properties you want to update as a 
list in the decorator, and return that many items from the callback. This is
particularly nice if two outputs depend on the same computationally intense intermediate 
result, such as a slow database query. The only change we have to make is setting the `Output`
as a list of `outputs`, and returning a list of each of the consecutive results.
  "),

    # Example of mutli-output
    examples$multi_output$source_code,
    examples$multi_output$layout,
    
    dccMarkdown("
A word of caution: it's not always a good idea to combine Outputs, even if
you can:

- If the Outputs depend on some but not all of the same Inputs, keeping
  them separate can avoid unnecessary updates.
- If they have the same Inputs but do independent computations with these
  inputs, keeping the callbacks separate can allow them to run in parallel.
  
  "),

    dccMarkdown("
#### Chained Callbacks

You can also chain outputs and inputs together: the output of one callback
function could be the input of another callback function.

This pattern can be used to create dynamic UIs where one input component
updates the available options of the next input component.
Here's a simple example.
  "),

    # Example of mutli-output
    examples$multi_output2$source_code,
    examples$multi_output2$layout,

    dccMarkdown("
The first callback updates the available options in the second `dccRadioItems`
component based off of the selected value in the first `dccRadioItems` component.

The second callback sets an initial value when the `options` property changes:
it sets it to the first value in that `options` list.

The final callback displays the selected `value` of each component.
If you change the `value` of the countries `dccRadioItems` component, Dash
will wait until the `value` of the cities component is updated
before calling the final callback. This prevents your callbacks from being
called with inconsistent state like with `\"USA\"` and `\"Montr\U{00E9}al\"`.
  "),
    
dccMarkdown("
#### State

In some cases, you might have a 'form'-type pattern in your
application. In such a situation, you might want to read the value
of the input component, but only when the user is finished
entering all of his or her information in the form.

Attaching a callback to the input values directly can look like
this:

  "),

#example of callback tied to input value
examples$basic_input$source,
examples$basic_input$layout,

dccMarkdown("
In this example, the callback function is fired whenever any of the
attributes described by the `input` change.
Try it for yourself by entering data in the inputs above.

`state` allows you to pass along extra values without
firing the callbacks. Here's the same example as above but with the
`dccInput` as `state` and a button as
`input`.
  "),

#example of one input and two states
examples$basic_state$source,
examples$basic_state$layout,

dccMarkdown("
In this example, changing text in the `dccInput` boxes won't fire
the callback but clicking on the button will. The current values of
the `dccInput` values are still passed into the callback even though
they don't trigger the callback function itself.

Note that we're triggering the callback by listening to the
`n_clicks` property of the `htmlButton` component. `n_clicks` is a
property that gets incremented every time the component has been
clicked on. It is available in every component in the
`dashHtmlComponents` package.
  "),

    dccMarkdown("
### Summary

We've covered the fundamentals of callbacks in Dash.
Dash apps are built of a set
of simple but powerful principles: declarative UIs that are customizable
through reactive and functional R callbacks.
Every element attribute of the declarative components can be updated through
a callback and a subset of the attributes, like the `value` properties of
the `dccDropdown`, are editable by the user in the interface.

***
  "),

    dccMarkdown("
The next part of the Dash tutorial covers an additional concept of
Dash callbacks: `state`
  "),

    dccLink(
      'Dash Tutorial Part 4: Interactive Graphing',
      href="/interactive-graphing"
    ),

    htmlHr(),
    dccMarkdown("
[Back to the Table of Contents](/)
                ")
  )
)
