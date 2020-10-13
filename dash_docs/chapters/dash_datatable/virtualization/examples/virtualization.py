import dash
import dash_table
import pandas as pd


app = dash.Dash(__name__)

df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/Emissions%20Data.csv').reset_index()
df['Emission'] = df['Emission'].map(lambda x: '{0:.2f}'.format(x))

app.layout = dash_table.DataTable(
        id='table-virtualization',
        data=df.to_dict('records'),
        columns=[
            {'name': i, 'id': i} for i in df.columns
        ],
        fixed_rows={ 'headers': True, 'data': 0 },
        style_cell={
            'whiteSpace': 'normal'
        },
        style_data_conditional=[
            {'if': {'column_id': 'index'},
             'width': '50px'},
            {'if': {'column_id': 'Year'},
             'width': '50px'},
            {'if': {'column_id': 'Country'},
             'width': '100px'},
            {'if': {'column_id': 'Continent'},
             'width': '70px'},
            {'if': {'column_id': 'Emission'},
             'width': '75px'},
        ],
        virtualization=True,
        page_action='none'
)


if __name__ == '__main__':
    app.run_server(debug=True)
