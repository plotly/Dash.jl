from time import sleep

from random import randint, seed

import dash
from dash.exceptions import PreventUpdate
from dash.dependencies import Input, Output
import dash_table
import dash_core_components as dcc
import dash_html_components as html

# For the documentation to always render the same values
seed(0)

app = dash.Dash(__name__)

app.layout = html.Div([

    'Choose property to load: ',
    dcc.Dropdown(
        id='loading-states-table-prop',
        options=[
            {'label': prop, 'value': prop}
            for prop in ['style_cell', 'data']
        ]
    ),

    html.Br(),

    dash_table.DataTable(
        id='loading-states-table',
        columns=[{
            'name': 'Column {}'.format(i),
            'id': 'column-{}'.format(i),
            'deletable': True,
            'renamable': True
        } for i in range(1, 5)],
        data=[
            {'column-{}'.format(i):
             (randint(0, 100)) for i in range(1, 5)}
            for j in range(5)
        ],
        editable=True
    )
])


@app.callback(
    Output('loading-states-table', 'style_cell'),
    [Input('loading-states-table-prop', 'value')]
)
def loading_style_cell(value):
    if value == 'style_cell':
        sleep(5)
        return {'color': 'rgb({}, {}, {})'.format(
            randint(0, 255),
            randint(0, 255),
            randint(0, 255)
        )}
    raise PreventUpdate


@app.callback(
    Output('loading-states-table', 'data'),
    [Input('loading-states-table-prop', 'value')]
)
def loading_data(value):
    if value == 'data':
        sleep(5)
        return [
            {'column-{}'.format(i):
             (randint(0, 100)) for i in range(5)}
            for j in range(5)
        ]
    raise PreventUpdate


if __name__ == '__main__':
    app.run_server(debug=True)
