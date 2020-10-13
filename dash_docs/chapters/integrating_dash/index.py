# -*- coding: utf-8 -*-

import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import reusable_components as rc


layout = html.Div([
    rc.Markdown(
    """
    # Integrating Dash with Existing Web Apps

    This section describes three different approaches to embedding a Dash app
    within an existing web application.

    > Heads up! If you are a [**Dash Enterprise**](https://plotly.com/dash) customer,
    > then you can use the
    > Dash Embedded Middleware library that is included in your license.
    > `dash-embedded` provides a secure mechanism for embedding Dash apps
    > into an existing website without iframes. It also provides hooks into
    > your existing website's login and authentication logic so that only
    > users who have logged into the existing host web application can view
    > the embedded Dash application.

    ## Using an `<iframe>`

    The simplest approach to embedding Dash in an existing web application is to
    include an `<iframe>` element in your HTML whose `src` attribute points
    towards the address of a deployed Dash app. This allows you to place your
    Dash app in a specific location within an existing web page with your
    desired dimensions:"""),
    rc.Markdown(
    '''
    ```html
    <iframe src="http://localhost:8050" width=700 height=600>
    ```
    '''),
    rc.Markdown(
    """
    ## Embedding a Dash app within an Existing Flask App

    As discussed in the <dccLink href="/deployment" children="Deployment Chapter"/>, Dash uses the Flask
    web framework under the hood. This makes it fairly straightforward to
    embed a Dash app at a specific route of an existing Flask app.

    In the following example, a Dash app is mounted at the `/dash` route (eg
    `http://localhost:8050/dash`) of a Flask app:
    """
    ),
    rc.Syntax(
        '''
        import flask
        import dash
        import dash_html_components as html

        server = flask.Flask(__name__)

        @server.route('/')
        def index():
            return 'Hello Flask app'

        app = dash.Dash(
            __name__,
            server=server,
            routes_pathname_prefix='/dash/'
        )

        app.layout = html.Div("My Dash app")

        if __name__ == '__main__':
            app.run_server(debug=True)
        '''
    ),
    rc.Markdown(
    """
    > **Note**: it is important to set the `name` parameter of the Dash instance
    to the value `__name__`, so that Dash can correctly detect the location of
    any static assets inside an `assets` directory for this Dash app.
    """
    ),
    html.Hr(),
    rc.Markdown(
    """
    ## Combining One or More Dash Apps with Existing WSGI Apps

    This approach uses Werkzeug's
    [`DispatcherMiddleware`](http://werkzeug.pocoo.org/docs/latest/middleware/)
    to combine one or more Dash apps with existing WSGI apps (including
    Flask). It is useful when you want to combine multiple Dash apps or when
    your existing app is a non-Flask WSGI app.

    The following example illustrates this approach by combining two Dash apps
    with a Flask app.
    """
    ),
    rc.Markdown("`flask_app.py`"),
    rc.Syntax(
        '''
            from flask import Flask

            flask_app = Flask(__name__)

            @flask_app.route('/')
            def index():
                return 'Hello Flask app'
        '''
    ),
    html.Hr(),
    rc.Markdown("`app1.py`"),
    rc.Syntax(
        """
            import dash
            import dash_html_components as html

            app = dash.Dash(
                __name__,
                requests_pathname_prefix='/app1/'
            )

            app.layout = html.Div("Dash app 1")
        """
    ),
    html.Hr(),
    rc.Markdown("`app2.py`"),
    rc.Syntax(
        """
            import dash
            import dash_html_components as html

            app = dash.Dash(
                __name__,
                requests_pathname_prefix='/app2/'
            )

            app.layout = html.Div("Dash app 2")
            """
    ),
    html.Hr(),
    rc.Markdown("`wsgi.py`"),
    rc.Syntax(
        """
            from werkzeug.middleware.dispatcher import DispatcherMiddleware

            from flask_app import flask_app
            from app1 import app as app1
            from app2 import app as app2

            application = DispatcherMiddleware(flask_app, {
                '/app1': app1.server,
                '/app2': app2.server,
            })
        """
    ),
    rc.Markdown(
        """
            In this example, the Flask app has been mounted at `/` and the two Dash apps
            have been mounted at `/app1` and `/app2`. In this approach, we do not pass
            in a Flask server to the Dash apps, but let them create their own, which the
            `DispatcherMiddleware` routes requests to based on the prefix of the
            incoming requests. Within each Dash app, `requests_pathname_prefix` must be
            specified as the app's mount point, in order to match the route prefix
            set by the `DispatcherMiddleware`.

            Note that the `application` object in `wsgi.py` is of type
            `werkzeug.wsgi.DispatcherMiddleware`, which does not have a `run`
            method. This can be run as a WSGI app like so:
        """
    ),
    rc.Syntax("$ gunicorn wsgi:application"),
    rc.Markdown(
    """
    Alternatively, you can use the Werkzeug development server (which is not
    suitable for production) to run the app:

    `run.py`
    """
    ),
    rc.Syntax(
        """
            from werkzeug.wsgi import DispatcherMiddleware
            from werkzeug.serving import run_simple

            from flask_app import flask_app
            from app1 import app as app1
            from app2 import app as app2

            application = DispatcherMiddleware(flask_app, {
                '/app1': app1.server,
                '/app2': app2.server,
            })

            if __name__ == '__main__':
                run_simple('localhost', 8050, application)
        """
    ),
    rc.Markdown(
    """
    If you need access to the Dash development tools when using this approach
    (whether running with a WSGI server, or using the Werkzeug development
    server) you must invoke them manually for each Dash app. The following lines
    can be added before the initialisation of the `DispatcherMiddleware` to do this:
    """
    ),
    rc.Syntax(
        """
            app1.enable_dev_tools(debug=True)
            app2.enable_dev_tools(debug=True)
        """
    ),
    rc.Markdown(
    """
    > **Note:** debug mode should not be enabled in production. When using debug
        mode with Gunicorn, the `--reload` command line flag is required for hot
        reloading to work.

    In this example, the existing app being combined with two Dash apps is a
    Flask app, however this approach enables the combination of any web
    application implementing the [WSGI
    specification](https://wsgi.readthedocs.io). A list of WSGI web frameworks
    can be found in the [WSGI
    documentation](https://wsgi.readthedocs.io/en/latest/frameworks.html) with
    one or more Dash apps.
    """
    ),
])
