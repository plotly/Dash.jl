import dash
from dash.dependencies import Input, Output
import dash_table
import dash_html_components as html
import datetime
import sys
import pandas as pd


df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv')
df = df[['continent', 'country', 'pop', 'lifeExp']]  # prune columns for example
df['Mock Date'] = [
    datetime.datetime(2020, 1, 1, 0, 0, 0) + i * datetime.timedelta(hours=13)
    for i in range(len(df))
]

app = dash.Dash(__name__)

def table_type(df_column):
    # Note - this only works with Pandas >= 1.0.0

    if sys.version_info < (3, 0):  # Pandas 1.0.0 does not support Python 2
        return 'any'

    if isinstance(df_column.dtype, pd.DatetimeTZDtype):
        return 'datetime',
    elif (isinstance(df_column.dtype, pd.StringDtype) or
            isinstance(df_column.dtype, pd.BooleanDtype) or
            isinstance(df_column.dtype, pd.CategoricalDtype) or
            isinstance(df_column.dtype, pd.PeriodDtype)):
        return 'text'
    elif (isinstance(df_column.dtype, pd.SparseDtype) or
            isinstance(df_column.dtype, pd.IntervalDtype) or
            isinstance(df_column.dtype, pd.Int8Dtype) or
            isinstance(df_column.dtype, pd.Int16Dtype) or
            isinstance(df_column.dtype, pd.Int32Dtype) or
            isinstance(df_column.dtype, pd.Int64Dtype)):
        return 'numeric'
    else:
        return 'any'

app.layout = dash_table.DataTable(
    columns=[
        {'name': i, 'id': i, 'type': table_type(df[i])} for i in df.columns
    ],
    data=df.to_dict('records'),
    filter_action='native',

    css=[{
        'selector': 'table',
        'rule': 'table-layout: fixed'  # note - this does not work with fixed_rows
    }],
    style_table={'height': 400},
    style_data={
        'width': '{}%'.format(100. / len(df.columns)),
        'textOverflow': 'hidden'
    }
)


if __name__ == '__main__':
    app.run_server(debug=True)
