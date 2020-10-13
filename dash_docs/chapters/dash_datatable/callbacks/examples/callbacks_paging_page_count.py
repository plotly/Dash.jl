import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import dash_table
import pandas as pd


df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv')

df[' index'] = range(1, len(df) + 1)

app = dash.Dash(__name__)

PAGE_SIZE = 5

app.layout = html.Div([
    dash_table.DataTable(
        id='datatable-paging-page-count',
        columns=[
            {"name": i, "id": i} for i in sorted(df.columns)
        ],
        page_current=0,
        page_size=PAGE_SIZE,
        page_action='custom'
    ),
    html.Br(),
    dcc.Checklist(
        id='datatable-use-page-count',
        options=[
            {'label': 'Use page_count', 'value': 'True'}
        ],
        value=['True']
    ),
    'Page count: ',
    dcc.Input(
        id='datatable-page-count',
        type='number',
        min=1,
        max=29,
        value=20
    )
])


@app.callback(
    Output('datatable-paging-page-count', 'data'),
    [Input('datatable-paging-page-count', "page_current"),
     Input('datatable-paging-page-count', "page_size")])
def update_table(page_current,page_size):
    return df.iloc[
        page_current*page_size:(page_current+ 1)*page_size
    ].to_dict('records')

@app.callback(
    Output('datatable-paging-page-count', 'page_count'),
    [Input('datatable-use-page-count', 'value'),
     Input('datatable-page-count', 'value')])
def update_table(use_page_count, page_count_value):
    if len(use_page_count) == 0 or page_count_value is None:
        return None
    return page_count_value

if __name__ == '__main__':
    app.run_server(debug=True)
