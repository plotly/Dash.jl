import dash
from dash.dependencies import Input, Output, State
import dash_table
import dash_html_components as html

app = dash.Dash(__name__)

app.layout = html.Div([
    dash_table.DataTable(
        id='computed-table',
        columns=[
            {'name': 'Input Data', 'id': 'input-data'},
            {'name': 'Input Squared', 'id': 'output-data'}
        ],
        data=[{'input-data': i} for i in range(11)],
        editable=True,
    ),
])


@app.callback(
    Output('computed-table', 'data'),
    [Input('computed-table', 'data_timestamp')],
    [State('computed-table', 'data')])
def update_columns(timestamp, rows):
    for row in rows:
        try:
            row['output-data'] = float(row['input-data']) ** 2
        except:
            row['output-data'] = 'NA'
    return rows


if __name__ == '__main__':
    app.run_server(debug=True)
