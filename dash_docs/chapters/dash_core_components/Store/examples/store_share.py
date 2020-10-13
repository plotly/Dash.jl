import collections
import dash
import pandas as pd

from dash.dependencies import Output, Input
from dash.exceptions import PreventUpdate

import dash_html_components as html
import dash_core_components as dcc
import dash_table

app = dash.Dash(__name__)

df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv')

countries = set(df['country'])


app.layout = html.Div([
    dcc.Store(id='memory-output'),
    dcc.Dropdown(id='memory-countries', options=[
        {'value': x, 'label': x} for x in countries
    ], multi=True, value=['Canada', 'United States']),
    dcc.Dropdown(id='memory-field', options=[
        {'value': 'lifeExp', 'label': 'Life expectancy'},
        {'value': 'gdpPercap', 'label': 'GDP per capita'},
    ], value='lifeExp'),
    html.Div([
        dcc.Graph(id='memory-graph'),
        dash_table.DataTable(
            id='memory-table',
            columns=[{'name': i, 'id': i} for i in df.columns]
        ),
    ])
])


@app.callback(Output('memory-output', 'data'),
              [Input('memory-countries', 'value')])
def filter_countries(countries_selected):
    if not countries_selected:
        # Return all the rows on initial load/no country selected.
        return df.to_dict('records')

    filtered = df.query('country in @countries_selected')

    return filtered.to_dict('records')


@app.callback(Output('memory-table', 'data'),
              [Input('memory-output', 'data')])
def on_data_set_table(data):
    if data is None:
        raise PreventUpdate

    return data


@app.callback(Output('memory-graph', 'figure'),
              [Input('memory-output', 'data'),
               Input('memory-field', 'value')])
def on_data_set_graph(data, field):
    if data is None:
        raise PreventUpdate

    aggregation = collections.defaultdict(
        lambda: collections.defaultdict(list)
    )

    for row in data:

        a = aggregation[row['country']]

        a['name'] = row['country']
        a['mode'] = 'lines+markers'

        a['x'].append(row[field])
        a['y'].append(row['year'])

    return {
        'data': [x for x in aggregation.values()]
    }


if __name__ == '__main__':
    app.run_server(debug=True, threaded=True, port=10450)
