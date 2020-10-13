import dash
from dash.dependencies import Input, Output
import dash_html_components as html
import dash_table

import pprint

app = dash.Dash(__name__)

app.layout = html.Div([
    dash_table.DataTable(
        id='editing-prune-data',
        columns=[{
            'name': 'Column {}'.format(i),
            'id': 'column-{}'.format(i)
        } for i in range(1, 5)],
        data=[
            {'column-{}'.format(i): (j + (i-1)*5) for i in range(1, 5)}
            for j in range(5)
        ],
        editable=True
    ),
    html.Div(id='editing-prune-data-output')
])


@app.callback(Output('editing-prune-data-output', 'children'),
              [Input('editing-prune-data', 'data')])
def display_output(rows):
    pruned_rows = []
    for row in rows:
        # require that all elements in a row are specified
        # the pruning behavior that you need may be different than this
        if all([cell != '' for cell in row.values()]):
            pruned_rows.append(row)

    return html.Div([
        html.Div('Raw Data'),
        html.Pre(pprint.pformat(rows)),
        html.Hr(),
        html.Div('Pruned Data'),
        html.Pre(pprint.pformat(pruned_rows)),
    ])

if __name__ == '__main__':
    app.run_server(debug=True)
