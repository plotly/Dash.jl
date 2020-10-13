import dash_core_components as dcc
import dash_html_components as html
from dash_docs import reusable_components as rc

layout = html.Div(children=[rc.Markdown('''
# Live Updating Components

## The `dash_core_components.Interval` component

Components in Dash usually update through user interaction:
selecting a dropdown, dragging a slider, hovering over points.

If you're building an application for monitoring, you may want to update
components in your application every few seconds or minutes.

The `dash_core_components.Interval` element allows you to update components
on a predefined interval. The `n_intervals` property is an integer that is
automatically incremented every time `interval` milliseconds pass.
You can listen to this variable inside your app's `callback` to fire
the callback on a predefined interval.

This example pulls data from live satellite feeds and updates the graph
and the text every second.
'''),
    rc.Markdown('''
    ```python
    import datetime

    import dash
    import dash_core_components as dcc
    import dash_html_components as html
    import plotly
    from dash.dependencies import Input, Output

    # pip install pyorbital
    from pyorbital.orbital import Orbital
    satellite = Orbital('TERRA')

    external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

    app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
    app.layout = html.Div(
        html.Div([
            html.H4('TERRA Satellite Live Feed'),
            html.Div(id='live-update-text'),
            dcc.Graph(id='live-update-graph'),
            dcc.Interval(
                id='interval-component',
                interval=1*1000, # in milliseconds
                n_intervals=0
            )
        ])
    )


    @app.callback(Output('live-update-text', 'children'),
                  [Input('interval-component', 'n_intervals')])
    def update_metrics(n):
        lon, lat, alt = satellite.get_lonlatalt(datetime.datetime.now())
        style = {'padding': '5px', 'fontSize': '16px'}
        return [
            html.Span('Longitude: {0:.2f}'.format(lon), style=style),
            html.Span('Latitude: {0:.2f}'.format(lat), style=style),
            html.Span('Altitude: {0:0.2f}'.format(alt), style=style)
        ]


    # Multiple components can update everytime interval gets fired.
    @app.callback(Output('live-update-graph', 'figure'),
                  [Input('interval-component', 'n_intervals')])
    def update_graph_live(n):
        satellite = Orbital('TERRA')
        data = {
            'time': [],
            'Latitude': [],
            'Longitude': [],
            'Altitude': []
        }

        # Collect some data
        for i in range(180):
            time = datetime.datetime.now() - datetime.timedelta(seconds=i*20)
            lon, lat, alt = satellite.get_lonlatalt(
                time
            )
            data['Longitude'].append(lon)
            data['Latitude'].append(lat)
            data['Altitude'].append(alt)
            data['time'].append(time)

        # Create the graph with subplots
        fig = plotly.tools.make_subplots(rows=2, cols=1, vertical_spacing=0.2)
        fig['layout']['margin'] = {
            'l': 30, 'r': 10, 'b': 30, 't': 10
        }
        fig['layout']['legend'] = {'x': 0, 'y': 1, 'xanchor': 'left'}

        fig.append_trace({
            'x': data['time'],
            'y': data['Altitude'],
            'name': 'Altitude',
            'mode': 'lines+markers',
            'type': 'scatter'
        }, 1, 1)
        fig.append_trace({
            'x': data['Longitude'],
            'y': data['Latitude'],
            'text': data['time'],
            'name': 'Longitude vs Latitude',
            'mode': 'lines+markers',
            'type': 'scatter'
        }, 2, 1)

        return fig


    if __name__ == '__main__':
        app.run_server(debug=True)
    ```
    ''',
        style={'borderLeft': 'thin solid lightgrey'}
    ),

rc.Markdown('''

***

## Updates on Page Load

By default, Dash apps store the `app.layout` in memory. This ensures that the
`layout` is only computed once, when the app starts.

If you set `app.layout` to a function, then you can serve a dynamic layout
on every page load.

For example, if your `app.layout` looked like this:

```py
import datetime

import dash
import dash_html_components as html

app.layout = html.H1('The time is: ' + str(datetime.datetime.now()))

if __name__ == '__main__':
    app.run_server(debug=True)
```

then your app would display the time when the app was started.

If you change this to a function, then a new `datetime` will get computed
everytime you refresh the page. Give it a try:

```py
import datetime

import dash
import dash_html_components as html

def serve_layout():
    return html.H1('The time is: ' + str(datetime.datetime.now()))

app.layout = serve_layout

if __name__ == '__main__':
    app.run_server(debug=True)
```
> **Heads up! You need to write** `app.layout = serve_layout` **_not_** `app.layout = serve_layout()`.
> **That is, define** `app.layout` **to the actual function instance.**

You can combine this with <dccLink children="time-expiring caching" href="/performance"/>
and serve a unique `layout` every hour or every day and serve the computed `layout`
from memory in between.
''')])
