import dash_html_components as html
import dash_core_components as dcc

from dash_docs import reusable_components as rc

layout = html.Div([
    rc.Markdown('''
        ## Introduction to Dash

        Dash is a productive Python framework for building web applications.

        Written on top of Flask, Plotly.js, and React.js,
        Dash is ideal for building data visualization apps
        with highly custom user interfaces in pure Python.
        It's particularly suited for anyone who works with data in Python.

        Through a couple of simple patterns, Dash abstracts away all of the
        technologies and protocols that are required to build an
        interactive web-based application.
        Dash is simple enough that you can bind a user interface
        around your Python code in an afternoon.

        Dash apps are rendered in the web browser. You can deploy your apps
        to servers and then share them through URLs.
        Since Dash apps are viewed in the web browser, Dash is inherently
        cross-platform and mobile ready.

        There is a lot behind the framework. To learn more about how it is built
        and what motivated Dash, watch our talk from
        [Plotcon](https://plotcon.plotly.com) below
        or read our [announcement letter](https://medium.com/@plotlygraphs/introducing-dash-5ecf7191b503).

        Dash is an open source library, released under the permissive MIT license.
        [Plotly](https://plotly.com) develops Dash and offers a [platform for easily deploying Dash
        apps in an enterprise environment](https://plotly.com/dash).
        If you're interested, [please get in touch](https://plotly.com/get-demo/).

        ***

    '''.replace('  ', '')),

    html.Iframe(
        width='100%',
        height='480',
        style={'border': 'none'},
        src='https://www.youtube-nocookie.com/embed/5BAthiN0htc?rel=0'
    )
])
