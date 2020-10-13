import dash
from dash.dependencies import Input, Output, State
import dash_table
import dash_core_components as dcc
import dash_html_components as html

app = dash.Dash(__name__)

app.layout = html.Div([
    html.Div([
        dcc.Input(
            id='editing-columns-name',
            placeholder='Enter a column name...',
            value='',
            style={'padding': 10}
        ),
        html.Button('Add Column', id='editing-columns-button', n_clicks=0)
    ], style={'height': 50}),

    dash_table.DataTable(
        id='editing-columns',
        columns=[{
            'name': 'Column {}'.format(i),
            'id': 'column-{}'.format(i),
            'deletable': True,
            'renamable': True
        } for i in range(1, 5)],
        data=[
            {'column-{}'.format(i): (j + (i-1)*5) for i in range(1, 5)}
            for j in range(5)
        ],
        editable=True,
    ),

    dcc.Graph(id='editing-columns-graph')
])


@app.callback(
    Output('editing-columns', 'columns'),
    [Input('editing-columns-button', 'n_clicks')],
    [State('editing-columns-name', 'value'),
     State('editing-columns', 'columns')])
def update_columns(n_clicks, value, existing_columns):
    if n_clicks > 0:
        existing_columns.append({
            'id': value, 'name': value,
            'renamable': True, 'deletable': True
        })
    return existing_columns


@app.callback(
    Output('editing-columns-graph', 'figure'),
    [Input('editing-columns', 'data'),
     Input('editing-columns', 'columns')])
def display_output(rows, columns):
    return {
        'data': [{
            'type': 'heatmap',
            'z': [[row.get(c['id'], None) for c in columns] for row in rows],
            'x': [c['name'] for c in columns]
        }]
    }


if __name__ == '__main__':
    app.run_server(debug=True)
