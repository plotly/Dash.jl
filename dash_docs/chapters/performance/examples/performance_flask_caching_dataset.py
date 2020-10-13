import datetime as dt
import os
import time

import dash
import dash_core_components as dcc
import dash_html_components as html
import numpy as np
import pandas as pd
from dash.dependencies import Input, Output
from flask_caching import Cache

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
cache = Cache(app.server, config={
    'CACHE_TYPE': 'filesystem',
    'CACHE_DIR': 'cache-directory'
})

TIMEOUT = 60

@cache.memoize(timeout=TIMEOUT)
def query_data():
    # This could be an expensive data querying step
    df =  pd.DataFrame(
        np.random.randint(0,100,size=(100, 4)),
        columns=list('ABCD')
    )
    now = dt.datetime.now()
    df['time'] = [now - dt.timedelta(seconds=5*i) for i in range(100)]
    return df.to_json(date_format='iso', orient='split')


def dataframe():
    return pd.read_json(query_data(), orient='split')

app.layout = html.Div([
    html.Div('Data was updated within the last {} seconds'.format(TIMEOUT)),
    dcc.Dropdown(
        id='live-dropdown',
        value='A',
        options=[{'label': i, 'value': i} for i in dataframe().columns]
    ),
    dcc.Graph(id='live-graph')
])


@app.callback(Output('live-graph', 'figure'),
              [Input('live-dropdown', 'value')])
def update_live_graph(value):
    df = dataframe()
    now = dt.datetime.now()
    return {
        'data': [{
            'x': df['time'],
            'y': df[value],
            'line': {
                'width': 1,
                'color': '#0074D9',
                'shape': 'spline'
            }
        }],
        'layout': {
            # display the current position of now
            # this line will be between 0 and 60 seconds
            # away from the last datapoint
            'shapes': [{
                'type': 'line',
                'xref': 'x', 'x0': now, 'x1': now,
                'yref': 'paper', 'y0': 0, 'y1': 1,
                'line': {'color': 'darkgrey', 'width': 1}
            }],
            'annotations': [{
                'showarrow': False,
                'xref': 'x', 'x': now, 'xanchor': 'right',
                'yref': 'paper', 'y': 0.95, 'yanchor': 'top',
                'text': 'Current time ({}:{}:{})'.format(
                    now.hour, now.minute, now.second),
                'bgcolor': 'rgba(255, 255, 255, 0.8)'
            }],
            # aesthetic options
            'margin': {'l': 40, 'b': 40, 'r': 20, 't': 10},
            'xaxis': {'showgrid': False, 'zeroline': False},
            'yaxis': {'showgrid': False, 'zeroline': False}
        }
    }


if __name__ == '__main__':
    app.run_server(debug=True)
