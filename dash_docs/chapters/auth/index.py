# -*- coding: utf-8 -*-
import dash
import dash_core_components as dcc
import dash_html_components as html
import dash_auth
from dash_docs import styles
from dash_docs import reusable_components as rc
from textwrap import dedent

layout = html.Div([
    rc.Markdown('''
    > This chapter covers two forms of authentication maintained by Plotly:
    >
    > 1. `dash-enterprise-auth`, the authentication and authorization layer built-in
    > to Plotly's commercial product, [Dash Enterprise](https://plotly.com/dash).
    >
    > 2. `dash-auth`, a simple [basic auth](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication)
    > implementation.

    # Dash Enterprise Auth

    [Dash Enterprise](https://plotly.com/dash/) provides
    an [authentication middleware](https://plotly.com/dash/app-manager/)
    that is configured by your administrator.
    This authentication middleware connects to your
    organization's LDAP or SAML identity provider
    (e.g. Active Directory, Ping Federate), allows your end users to log in
    with SSO, verifies if the user has permission to view the application,
    and then passes along user information like their username or group.

    Once Dash Enterprise is installed, no extra configuration is required
    on the application layer.

    The `dash-enterprise-auth` package provides the API to access the username
    of the viewer of your Dash application. Use this username to
    conditional logic depending on who is logged in or to use that username
    in your API or database calls (row level security).

    Dash Enterprise will automatically implement app authorization if your
    <dccLink children="Dash app's privacy" href="/dash-enterprise/privacy"/>
    is set to *Restricted* (the default setting)
    or *Authorized* but not if is set to *Unauthorized*.

    ## Using `dash-enterprise-auth` in an Existing Dash App

    If you have previously deployed your Dash app to your Dash Enterprise,
    simply add `dash-enterprise-auth` to your `requirements.txt` file.

    `dash-enterprise-auth` includes the method `create_logout_button` which allows you to
    add a logout button to your app's layout and it also includes three other methods,
    `get_username`, `get_user_data` and `get_kerberos_ticket_cache` (only applicable for
    certain server configurations), which provide information about the app's viewer and so
    must be called from within callbacks.

    The example below demonstrates how to use these callbacks. Note that in order to use
    `create_logout_button` locally you will have to set an environment variable called
    `DASH_LOGOUT_URL`. You can do this by running your code with `DASH_LOGOUT_URL=plot.ly python app.py`.

    ## Dash Enterprise Auth Example
    '''),

    rc.Syntax(dedent('''
    import dash
    from dash.dependencies import Input, Output
    import dash_core_components as dcc
    import dash_html_components as html
    import dash_enterprise_auth as auth


    external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

    app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

    server = app.server  # Expose the server variable for deployments

    # Standard Dash app code below
    app.layout = html.Div(className='container', children=[

        html.Div([
            html.H2('Sample App', id='header-title', className='ten columns'),
            html.Div(auth.create_logout_button(), className='two columns', style={'marginTop': 30})
        ]),
        html.Div(id='dummy-input', style={'display': 'none'}),

        html.Div([
            html.Div(
                className='four columns',
                children=[
                    dcc.Dropdown(
                        id='dropdown',
                        options=[{'label': i, 'value': i} for i in ['LA', 'NYC', 'MTL']],
                        value='LA'
                    )
            ]),
            html.Div(
                className='eight columns',
                children=[
                    dcc.Graph(id='graph')
                ])
        ])
    ])


    @app.callback(Output('header-title','children'),
                  [Input('dummy-input', 'children')])
    def update_title(_):

        # print user data to the logs
        print(auth.get_user_data())

        # update header with username
        return 'Hello {}'.format(auth.get_username())


    @app.callback(Output('graph', 'figure'),
                  [Input('dropdown', 'value')])
    def update_graph(value):
        return {
            'data': [{
                'x': [1, 2, 3, 4, 5, 6],
                'y': [3, 1, 2, 3, 5, 6]
            }],
            'layout': {
                'title': value,
                'margin': {
                    'l': 60,
                    'r': 10,
                    't': 40,
                    'b': 60
                }
            }
        }

    if __name__ == '__main__':
        app.run_server(debug=True)
    ''')),

    rc.Markdown('''

    ***

    # Basic Auth

    The [`dash-auth`](https://github.com/plotly/dash-auth) package provides a
    [HTTP Basic Auth](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication).

    As a Dash developer, you hardcode a set of usernames and passwords in your
    code and send those usernames and passwords to your viewers.
    There are a few limitations to HTTP Basic Auth:
    - Users can not log out of applications
    - You are responsible for sending the usernames and passwords
      to your viewers over a secure channel
    - Your viewers can not create their own account and cannot change their
      password
    - You are responsible for safely storing the username and password pairs in
      your code.

    '''.replace('    ', '')),

    rc.Markdown('''
    ## Basic Auth Example

    Logging in through Basic Auth looks like this:
    '''.replace('    ', '')),

    html.Img(
        src='https://raw.githubusercontent.com/plotly/dash-docs/master/images/basic-auth.gif',
        alt='Dash Basic Auth Example',
        style={
            'width': '100%', 'border': 'thin lightgrey solid',
            'border-radius': '4px'
        }),

    rc.Markdown('''
    Installation:
    '''.replace('    ', '')),

    rc.Markdown('''
    ```shell
    pip install dash=={}
    pip install dash-auth=={}
    ```
    '''.replace('    ', '').format(
        dash.__version__,
        dash_auth.__version__
    ), style=styles.code_container),

    rc.Markdown('''
    Example Code:
    '''.replace('    ', '')),

    rc.Markdown('''
    ```python
    import dash
    import dash_auth
    import dash_core_components as dcc
    import dash_html_components as html
    import plotly

    # Keep this out of source code repository - save in a file or a database
    VALID_USERNAME_PASSWORD_PAIRS = {
        'hello': 'world'
    }

    external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

    app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
    auth = dash_auth.BasicAuth(
        app,
        VALID_USERNAME_PASSWORD_PAIRS
    )

    app.layout = html.Div([
        html.H1('Welcome to the app'),
        html.H3('You are successfully authorized'),
        dcc.Dropdown(
            id='dropdown',
            options=[{'label': i, 'value': i} for i in ['A', 'B']],
            value='A'
        ),
        dcc.Graph(id='graph')
    ], className='container')

    @app.callback(
        dash.dependencies.Output('graph', 'figure'),
        [dash.dependencies.Input('dropdown', 'value')])
    def update_graph(dropdown_value):
        return {
            'layout': {
                'title': 'Graph of {}'.format(dropdown_value),
                'margin': {
                    'l': 20,
                    'b': 20,
                    'r': 10,
                    't': 60
                }
            },
            'data': [{'x': [1, 2, 3], 'y': [4, 1, 2]}]
        }

    if __name__ == '__main__':
        app.run_server(debug=True)
    ```
    ''', style=styles.code_container),
])
