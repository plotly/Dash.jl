import dash
import dash_table
import pandas as pd

df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv')
df['filter_set_1'] = ((df['lifeExp'] > 30) & (df['lifeExp'] < 50))
df['filter_set_1'] *= 1  # cast to 1/0

app = dash.Dash(__name__)

app.layout = dash_table.DataTable(
    columns=[{'name': i, 'id': i} for i in df.columns],
    data=df.to_dict('records'),
    # hidden_columns=['filter_results'],
    filter_action='native',
    style_table={
        'height': 400,
    },
    style_data_conditional=[{
        'if': {'filter_query': '{filter_results} = 1'},
        'backgroundColor': 'hotpink',
        'color': 'white'
    }]
)


if __name__ == '__main__':
    app.run_server(debug=True)
