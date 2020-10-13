import dash_core_components as dcc
import dash_html_components as html

from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div([
    html.H1('Advanced Callbacks'),

    rc.Markdown('''
    ## Catching errors with `PreventUpdate`

    In certain situations, you don't want to update the callback output. You can
    achieve this by raising a `PreventUpdate` exception in the callback function.
    '''),
    rc.Syntax(examples['prevent_update_button.py'][0]),
    rc.Example(examples['prevent_update_button.py'][1]),

    rc.Markdown('''
    ## Displaying errors with `dash.no_update`

    This example illustrates how you can show an error while keeping the previous
    input, using `dash.no_update` to update the output partially.
    '''),
    rc.Syntax(examples['prevent_update.py'][0]),
    rc.Example(examples['prevent_update.py'][1]),

    rc.Markdown('''
    ## Determining which `Input` has fired with `dash.callback_context`

    In addition to event properties like `n_clicks`
    that change whenever an event happens (in this case a click), there is a
    global variable `dash.callback_context`, available only inside a callback.
    It has properties:
    - `triggered`: list of changed properties. This will be empty on initial
      load, unless an `Input` prop got its value from another initial callback.
      After a user action it is a length-1 list, unless two properties of a
      single component update simultaneously, such as a value and a timestamp
      or event counter.
    - `inputs` and `states`: allow you to access the callback params
      by id and prop instead of through the function args. These have the form
      of dictionaries `{ 'component_id.prop_name': value }`

    Here's an example of how this can be done:'''),

    rc.Syntax(examples['last_clicked_button.py'][0]),
    rc.Example(examples['last_clicked_button.py'][1]),
    rc.Markdown('''
    ### Legacy behaviour: using timestamps

    Prior to v0.38.0, you needed to compare timestamp properties like
    `n_clicks_timestamp` to find the most recent click. While existing uses of
    `*_timestamp` continue to work for now, this approach is deprecated, and
    may be removed in a future update. The one exception is
    `modified_timestamp` from `dcc.Store`, which is safe to use, it is NOT
    deprecated.

    ------------------------
    '''),

    rc.Markdown('''
    ## Improving performance with memoization

    Memoization allows you to bypass long computations by storing the
    results of function calls.

    To better understand how memoization works, let's start with a simple example.

'''),

    rc.Syntax('''
import time
import functools32

@functools32.lru_cache(maxsize=32)
def slow_function(input):
    time.sleep(10)
    return 'Input was {}'.format(input)
    '''),

    rc.Markdown('''
    Calling `slow_function('test')` the first time will take 10 seconds.
    Calling it a second time with the same argument will take almost no time
    since the previously computed result was saved in memory and reused.

    The [Performance](/performance) section of the Dash docs delves a
    little deeper into leveraging multiple processes and threads in
    conjunction with memoization to further improve performance.
    '''),

    rc.Markdown('''
    ## When Are Callbacks Executed?

    This section describes the circumstances under which the `dash-renderer` front-end client can make a request to the Dash back-end server (or the clientside callback code) to execute a callback function.

    ### When A Dash App First Loads

    All of the callbacks in a Dash app are executed with the initial value of their inputs when the app is first loaded. This is known as the "initial call" of the callback. To learn how to suppress this behavior, see the documentation for the [`prevent_initial_call`](#prevent-callbacks-from-being-executed-on-initial-load) attribute of Dash callbacks.

    It is important to note that when a Dash app is initially loaded in a web browser by the `dash-renderer` front-end client, its entire callback chain is introspected recursively.

    This allows the `dash-renderer` to predict the order in which callbacks will need to be executed, as callbacks are blocked when their inputs are outputs of other callbacks which have not yet fired. In order to unblock the execution of these callbacks, first callbacks whose inputs are immediately available must be executed. This process helps the `dash-renderer` to minimize the time and effort it uses, and avoid unnecessarily redrawing the page, by making sure it only requests that a callback is executed when all of the callback's inputs have reached their final values.

    Examine the following Dash app:
    '''),

    rc.Syntax(examples['callbacks-initial-call.py'][0]),
    rc.Example(examples['callbacks-initial-call.py'][1]),

    rc.Markdown('''
    Notice that when this app is finished being loaded by a web browser and ready for user interaction, the `html.Div` components do not say "callback not executed" as declared in the app's layout, but rather "n_clicks is None," the result of the `change_text()` callback being executed. This is because the "initial call" of the callback occurred with `n_clicks` having the value of `None`.

    ### As A Direct Result of User Interaction

    Most frequently, callbacks are executed as a direct result of user interaction, such as clicking a button or selecting an item in a dropdown menu. When such interactions occur, Dash components communicate their new values to the `dash-renderer` front-end client, which then requests that the Dash server execute any callback function that has the newly changed value as input.

    If a Dash app has multiple callbacks, the `dash-renderer` requests callbacks to be executed based on whether or not they can be immediately executed with the newly changed inputs. If several inputs change simultaneously, then requests are made to execute them all.

    Whether or not these requests are executed in a synchronous or asyncrounous manner depends on the specific setup of the Dash back-end server. If it is running in a multi-threaded environment, then all of the callbacks can be executed simultaneously, and they will return values based on their speed of execution. In a single-threaded environment however, callbacks will be executed one at a time in the order they are received by the server.

    In the example application above, clicking the button results in the callback being executed.

    ### As An Indirect Result of User Interaction

    When a user interacts with a component, the resulting callback might have outputs that are themselves the input of other callbacks. The `dash-renderer` will block the execution of such a callback until the callback whose output is its input has been executed.

    Take the following Dash app:

    '''),

    rc.Syntax(examples['callbacks-user-interaction.py'][0]),
    rc.Example(examples['callbacks-user-interaction.py'][1]),

        rc.Markdown('''

    The above Dash app demonstrates how callbacks chain together. Notice that if you first click "execute slow callback" and then click "execute fast callback", the third callback is not executed until after the slow callback finishes executing. This is because the third callback has the second callback's output as its input, which lets the `dash-renderer` know that it should delay its execution until after the second callback finishes.


    ### When Dash Components Are Added To The Layout

    It is possible for a callback to insert new Dash components into a Dash app's layout. If these new components are themselves the inputs to other callback functions, then their appearance in the Dash app's layout will trigger those callback functions to be executed.

    In this circumstance, it is possible that multiple requests are made to execute the same callback function. This would occur if the callback in question has already been requested and its output returned before the new components which are also its inputs are added to the layout.

    '''),


    rc.Markdown('''
    ## Prevent Callbacks From Being Executed on Initial Load

    You can use the `prevent_initial_call` attribute of callbacks to prevent callbacks from being fired when the app initially loads, as in the following example app.
    '''),

    rc.Syntax(examples['callbacks-prevent-initial-call.py'][0]),
    rc.Example(examples['callbacks-prevent-initial-call.py'][1]),

])
