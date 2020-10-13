import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output, State, MATCH, ALL, ALLSMALLER
import pandas as pd

df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv')

app = dash.Dash(__name__, suppress_callback_exceptions=True)

app.layout = html.Div([
    html.Button('Add Filter', id='add-filter-ex3', n_clicks=0),
    html.Div(id='container-ex3', children=[]),
])

@app.callback(
    Output('container-ex3', 'children'),
    [Input('add-filter-ex3', 'n_clicks')],
    [State('container-ex3', 'children')])
def display_dropdowns(n_clicks, existing_children):
    existing_children.append(html.Div([
        dcc.Dropdown(
            id={
                'type': 'filter-dropdown-ex3',
                'index': n_clicks
            },
            options=[{'label': i, 'value': i} for i in df['country'].unique()],
            value=df['country'].unique()[n_clicks]
        ),
        html.Div(id={
            'type': 'output-ex3',
            'index': n_clicks
        })
    ]))
    return existing_children


@app.callback(
    Output({'type': 'output-ex3', 'index': MATCH}, 'children'),
    [Input({'type': 'filter-dropdown-ex3', 'index': MATCH}, 'value'),
     Input({'type': 'filter-dropdown-ex3', 'index': ALLSMALLER}, 'value')],
)
def display_output(matching_value, previous_values):
    previous_values_in_reversed_order = previous_values[::-1]
    all_values = [matching_value] + previous_values_in_reversed_order

    dff = df[df['country'].str.contains('|'.join(all_values))]
    avgLifeExp = dff['lifeExp'].mean()

    # Return a slightly different string depending on number of values
    if len(all_values) == 1:
        return html.Div('{:.2f} is the life expectancy of {}'.format(
            avgLifeExp, matching_value
        ))
    elif len(all_values) == 2:
        return html.Div('{:.2f} is the average life expectancy of {}'.format(
            avgLifeExp, ' and '.join(all_values)
        ))
    else:
        return html.Div('{:.2f} is the average life expectancy of {}, and {}'.format(
            avgLifeExp, ', '.join(all_values[:-1]), all_values[-1]
        ))

if __name__ == '__main__':
    app.run_server(debug=True)
