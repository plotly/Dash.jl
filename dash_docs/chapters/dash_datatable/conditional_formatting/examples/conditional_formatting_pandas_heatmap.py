import dash
import dash_table
import pandas as pd

df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv')
df['filter_set'] = ((df['lifeExp'] < 30)) * 1
df['filter_set'][(df['lifeExp'] >= 30) & (df['lifeExp'] < 50)] = 2
df['filter_set'][(df['lifeExp'] >= 50) & (df['lifeExp'] < 70)] = 3
df['filter_set'][(df['lifeExp'] >= 70)] = 4

COLORSCALE = ['#440154', '#26828e', '#35b779', '#fde725']

app = dash.Dash(__name__)


app.layout = dash_table.DataTable(
    columns=[{'name': i, 'id': i} for i in df.columns],
    data=df.to_dict('records'),
    # hidden_columns=['filter_results'],
    filter_action='native',
    style_table={
        'height': 400,
    },
    style_data_conditional=[
        {
            'if': {'filter_query': '{{filter_set}} = {}'.format(i+1)},
            'backgroundColor': COLORSCALE[i],
            'color': 'white'
        } for i in range(len(COLORSCALE))
    ]
)


if __name__ == '__main__':
    app.run_server(debug=True)
