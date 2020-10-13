# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs.tools import load_example, read_file
from dash_docs import reusable_components as rc

layout = html.Div([
    html.H1(["Loading States"]),
    rc.Markdown('''
    Every component in `dash_core_components` or `dash_html_components` comes equipped with
    a `loading_state` prop. This prop contains an `is_loading` bool that tells you if the component is loading.
    Additionally, the `component_name` and `prop_name` attributes return the name of that component and the name of the
    property that is loading (i.e. "layout"). Component authors can use this prop to determine what to do if the component is still loading.
    Dash uses this prop in the `Loading` component to display spinners if a component is loading. This means you can use the `Loading` component
    to wrap other components that you want to display a loading spinner for. Here's an example of what that looks like:
    '''),
    rc.Markdown('''
    ```python
    # -*- coding: utf-8 -*-
    import dash
    import dash_html_components as html
    import dash_core_components as dcc
    import time

    from dash.dependencies import Input, Output, State

    app = dash.Dash(__name__)

    app.layout = html.Div(
        children=[
            html.H3("Edit text input to see loading state"),
            dcc.Input(id="input-1", value='Input triggers local spinner'),
            dcc.Loading(id="loading-1", children=[html.Div(id="loading-output-1")], type="default"),
            html.Div(
                [
                    dcc.Input(id="input-2", value='Input triggers nested spinner'),
                    dcc.Loading(
                        id="loading-2",
                        children=[html.Div([html.Div(id="loading-output-2")])],
                        type="circle",
                    )
                ]
            ),
        ],
    )

    @app.callback(Output("loading-output-1", "children"), [Input("input-1", "value")])
    def input_triggers_spinner(value):
        time.sleep(1)
        return value


    @app.callback(Output("loading-output-2", "children"), [Input("input-2", "value")])
    def input_triggers_nested(value):
        time.sleep(1)
        return value


    if __name__ == "__main__":
        app.run_server(debug=False)
    ```
    ''', style=styles.code_container),
    html.Br(),
    rc.Markdown('''
    Please also check out the docs for the <dccLink href="/dash-core-components/loading" children="Loading component"/> for more information on how to use the Loading component.

    Aside from using the <dccLink href="/dash-core-components/loading" children="Loading component"/>,
    you can check if a certain component
    (either from `dash_core_components` or `dash_html_components`) is loading by checking the
    `data-dash-is-loading` attribute set on that component's HTML output. This means that
    you can target those components yourself with CSS, and create your own custom spinner
    for them. Here's an example of what that could look like:
    '''),
    rc.Markdown('''
    ```python
    # -*- coding: utf-8 -*-
    import dash
    import dash_html_components as html
    import dash_core_components as dcc
    import time

    from dash.dependencies import Input, Output, State

    app = dash.Dash(__name__)

    app.layout = html.Div(
        children=[
            html.Div(id="output-1"),
            dcc.Input(id="input-1", value="Input triggers local spinner"),
            html.Div(
                [
                    html.Div(id="output-2"),
                    dcc.Input(id="input-2", value="Input triggers nested spinner"),
                ]
            ),
        ]
    )


    @app.callback(Output("output-1", "children"), [Input("input-1", "value")])
    def input_triggers_spinner(value):
        time.sleep(1)
        return value


    @app.callback(Output("output-2", "children"), [Input("input-2", "value")])
    def input_triggers_nested(value):
        time.sleep(1)
        return value


    if __name__ == "__main__":
        app.run_server(debug=False)
    ```
    ''', style=styles.code_container),
    html.Br(),
    html.P("You could target all components in the layout above that are loading using the following CSS:"),
    rc.Markdown('''
    ```css
    *[data-dash-is-loading="true"]{
        visibility: hidden;
    }
    *[data-dash-is-loading="true"]::before{
        content: "Loading...";
        display: inline-block;
        color: magenta;
        visibility: visible;
    }
    ```
    ''', style=styles.code_container)
])
