import dash_core_components as dcc
import dash_html_components as html

from dash_docs import tools, styles
from dash_docs import reusable_components as rc
from textwrap import dedent

examples = tools.load_examples(__file__)

layout = html.Div([
    html.H1('Clientside Callbacks'),

    rc.Markdown('''
    Sometimes callbacks can incur a significant overhead, especially when they:
    - receive and/or return very large quantities of data (transfer time)
    - are called very often (network latency, queuing, handshake)
    - are part of a callback chain that requires multiple roundtrips
    between the browser and Dash

    When the overhead cost of a callback becomes too great and no
    other optimization is possible, the callback can be modified to be run
    directly in the browser instead of a making a request to Dash.

    The syntax for the callback is almost exactly the same; you use
    `Input` and `Output` as you normally would when declaring a callback,
    but you also define a JavaScript function as the first argument to the
    `@app.callback` decorator.

    For example, the following callback:

'''),

    rc.Syntax('''
    @app.callback(
        Output('out-component', 'value'),
        [Input('in-component1', 'value'), Input('in-component2', 'value')]
    )
    def large_params_function(largeValue1, largeValue2):
        largeValueOutput = someTransform(largeValue1, largeValue2)

        return largeValueOutput
    '''),

    rc.Markdown('''

    ***

    Can be rewritten to use JavaScript like so:

'''),

    rc.Syntax(dedent(
    '''
    from dash.dependencies import Input, Output

    app.clientside_callback(
        """
        function(largeValue1, largeValue2) {
            return someTransform(largeValue1, largeValue2);
        }
        """,
        Output('out-component', 'value'),
        [Input('in-component1', 'value'), Input('in-component2', 'value')]
    )
    ''')),

    rc.Markdown('''

    ***

    You also have the option of defining the function in a `.js` file in
    your `assets/` folder. To achieve the same result as the code above,
    the contents of the `.js` file would look like this:

    '''),

    rc.Syntax(dedent(
    '''
    window.dash_clientside = Object.assign({}, window.dash_clientside, {
        clientside: {
            large_params_function: function(largeValue1, largeValue2) {
                return someTransform(largeValue1, largeValue2);
            }
        }
    });
    ''')),

    rc.Markdown('''

    ***

    In Dash, the callback would now be written as:

    '''),

    rc.Syntax(dedent(
    '''
    from dash.dependencies import ClientsideFunction, Input, Output

    app.clientside_callback(
        ClientsideFunction(
            namespace='clientside',
            function_name='large_params_function'
        ),
        Output('out-component', 'value'),
        [Input('in-component1', 'value'), Input('in-component2', 'value')]
    )
    ''')),

    rc.Markdown('''

    ***

    ## A simple example

    Below are two examples of using clientside callbacks to update a
    graph in conjunction with a `dcc.Store` component. In these
    examples, we update a `dcc.Store` component on the backend; to
    create and display the graph, we have a clientside callback in the
    frontend that adds some extra information about the layout that we
    specify using the radio buttons under "Graph scale".

    '''),

    rc.Syntax(examples['graph_update_fe_be.py'][0]),
    rc.Example(examples['graph_update_fe_be.py'][1]),

    rc.Markdown('''

    Note that, in this example, we are manually creating the `figure`
    dictionary by extracting the relevant data from the
    dataframe. This is what gets stored in our `dcc.Store` component;
    expand the "Contents of figure storage" above to see exactly what
    is used to construct the graph.

    ### Using Plotly Express to generate a figure

    Plotly Express enables you to create one-line declarations of
    figures. When you create a graph with, for example,
    `plotly_express.Scatter`, you get a dictionary as a return
    value. This dictionary is in the same shape as the `figure`
    argument to a `dcc.Graph` component. (See
    [here](https://plotly.com/python/creating-and-updating-figures/) for
    more information about the shape of `figure`s.)

    We can rework the example above to use Plotly Express.

    '''),

    rc.Syntax(examples['graph_update_fe_be_px.py'][0]),
    rc.Example(examples['graph_update_fe_be_px.py'][1]),

    rc.Markdown('''

    Again, you can expand the "Contents of figure storage" section
    above to see what gets generated. You may notice that this is
    quite a bit more extensive than the previous example; in
    particular, a `layout` is already defined. So, instead of creating
    a `layout` as we did previously, we have to mutate the existing
    layout in our JavaScript code.

    ***

    **Note**: There are a few limitations to keep in mind:

    1. Clientside callbacks execute on the browser's main thread and wil block
    rendering and events processing while being executed.
    2. Dash does not currently support asynchronous clientside callbacks and will
    fail if a `Promise` is returned.
    3. Clientside callbacks are not possible if you need to refer to global
    variables on the server or a DB call is required.
    ''')

])
