library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  prevent_update_button=utils$LoadExampleCode('dash_docs/chapters/advanced_callbacks/examples/prevent_update_button.R'),
  prevent_update=utils$LoadExampleCode('dash_docs/chapters/advanced_callbacks/examples/prevent_update.R'),
  last_clicked_button=utils$LoadExampleCode('dash_docs/chapters/advanced_callbacks/examples/last_clicked_button.R'),
  callbacks_initial_R=utils$LoadExampleCode('dash_docs/chapters/advanced_callbacks/examples/callbacks-initial-call.R'),
  callbacks_user_interaction=utils$LoadExampleCode('dash_docs/chapters/advanced_callbacks/examples/callbacks-user-interaction.R')
)

layout <- htmlDiv(
  list(
    # htmlH1('Advanced Callbacks'),
    dccMarkdown("
## Catching errors with `dashNoUpdate()`
In certain situations, you don't want to update the callback output. You can
achieve this by returning a `dashNoUpdate()` in the callback function.
  "),

    examples$prevent_update_button$source_code,
    examples$prevent_update_button$layout,

    dccMarkdown("
## Displaying errors with `dashNoUpdate()`
This example illustrates how you can show an error while keeping the previous
input, using `dashNoUpdate()` to update the output partially.
  "),

    examples$prevent_update$source_code,
    examples$prevent_update$layout,

    dccMarkdown("
## Determining which `Input` has fired with `callback_context()`
In addition to event properties like `n_clicks` that change whenever
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
### Legacy behavior: Using timestamps
Prior to the addition of `callback_context`, you needed to compare timestamp properties
like `n_clicks_timestamp` to find the most recent click.
While existing uses of `*_timestamp` continue to work for now, this approach is deprecated,
and may be removed in a future update. The one exception is `modified_timestamp` from `dccStore`,
which is safe to use, it is NOT deprecated.
  "),

    dccMarkdown("
## Improving performance with memoization
Memoization allows you to bypass long computations by storing the results of function calls.

To better understand how memoization works, let's start with a simple example.
  "),

    dccMarkdown("
```r
library(memoise)

# We can start by memoising the function sys.sleep
memoised_sleep <- memoise::memoise(Sys.sleep)

# The first time it is called will take the full 10 seconds
memoised_sleep(10)

# The second time it will instantly execute.
memoised_sleep(10)
```
    "),

    dccMarkdown("
Calling `memoised_sleep(10)` the first time will take 10 seconds.
Calling it a second time with the same argument will take almost no time
since the previously computed result was saved in memory and reused.

The [Performance](/performance) section of the Dash docs delves a
little deeper into leveraging multiple processes and threads in
conjunction with memoization to further improve performance.
"),

dccMarkdown("
    ## When Are Callbacks Executed?

    This section describes the circumstances under which the `dash-renderer` front-end client can make a request to the Dash back-end server (or the clientside callback code) to execute a callback function.

    ### When A Dash App First Loads

    All of the callbacks in a Dash app are executed with the initial value of their inputs when the app is first loaded. This is known as the \"initial call\" of the callback.

    It is important to note that when a Dash app is initially loaded in a web browser by the `dash-renderer` front-end client, its entire callback chain is introspected recursively.

    This allows the `dash-renderer` to predict the order in which callbacks will need to be executed, as callbacks are blocked when their inputs are outputs of other callbacks which have not yet fired. In order to unblock the execution of these callbacks, first callbacks whose inputs are immediately available must be executed. This process helps the `dash-renderer` to minimize the time and effort it uses, and avoid unnecessarily redrawing the page, by making sure it only requests that a callback is executed when all of the callback\'s inputs have reached their final values.

    Examine the following Dash app:"),

    examples$callbacks_initial_R$source_code,
    examples$callbacks_initial_R$layout,



    dccMarkdown("

    Notice that when this app is finished being loaded by a web browser and ready for user interaction, the `html.Div` components do not say \"callback not executed\" as declared in the app's layout, but rather \"n_clicks is None,\" the result of the `change_text()` callback being executed. This is because the \"initial call\" of the callback occurred with `n_clicks` having the value of `None`.

    ### As A Direct Result of User Interaction

    Most frequently, callbacks are executed as a direct result of user interaction, such as clicking a button or selecting an item in a dropdown menu. When such interactions occur, Dash components communicate their new values to the `dash-renderer` front-end client, which then requests that the Dash server execute any callback function that has the newly changed value as input.

    If a Dash app has multiple callbacks, the `dash-renderer` requests callbacks to be executed based on whether or not they can be immediately executed with the newly changed inputs. If several inputs change simultaneously, then requests are made to execute them all.

    Whether or not these requests are executed in a synchronous or asyncrounous manner depends on the specific setup of the Dash back-end server. If it is running in a multi-threaded environment, then all of the callbacks can be executed simultaneously, and they will return values based on their speed of execution. In a single-threaded environment however, callbacks will be executed one at a time in the order they are received by the server.

    In the example application above, clicking the button results in the callback being executed.

    ### As An Indirect Result of User Interaction

    When a user interacts with a component, the resulting callback might have outputs that are themselves the input of other callbacks. The `dash-renderer` will block the execution of such a callback until the callback whose output is its input has been executed.

    Take the following Dash app: "),

    examples$callbacks_user_interaction$source_code,
    examples$callbacks_user_interaction$layout,

    dccMarkdown("

    The above Dash app demonstrates how callbacks chain together. Notice that if you first click \"execute slow callback\" and then click \"execute fast callback\", the third callback is not executed until after the slow callback finishes executing. This is because the third callback has the second callback's output as its input, which lets the `dash-renderer` know that it should delay its execution until after the second callback finishes.


    ### When Dash Components Are Added To The Layout

    It is possible for a callback to insert new Dash components into a Dash app\'s layout. If these new components are themselves the inputs to other callback functions, then their appearance in the Dash app\'s layout will trigger those callback functions to be executed.

    In this circumstance, it is possible that multiple requests are made to execute the same callback function. This would occur if the callback in question has already been requested and its output returned before the new components which are also its inputs are added to the layout.

    "),

    htmlHr(),
    dccMarkdown("
[Back to the Table of Contents](/)
                ")
  )
)
