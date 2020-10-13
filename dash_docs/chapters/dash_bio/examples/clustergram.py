import pandas as pd

import dash
import dash_bio as dashbio
import dash_html_components as html
import dash_core_components as dcc


external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

df = pd.read_csv(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'clustergram_mtcars.tsv',
    sep='	', skiprows=4
).set_index('model')

columns = list(df.columns.values)
rows = list(df.index)

app.layout = html.Div([
    "Rows to display",
    dcc.Dropdown(
        id='clustergram-input',
        options=[
            {'label': row, 'value': row} for row in list(df.index)
        ],
        value=rows[:10],
        multi=True
    ),

    html.Div(
        id='my-clustergram'
    )
])


@app.callback(
    dash.dependencies.Output('my-clustergram', 'children'),
    [dash.dependencies.Input('clustergram-input', 'value')]
)
def update_clustergram(rows):
    if len(rows) < 2:
        return "Please select at least two rows to display."

    return dcc.Graph(figure=dashbio.Clustergram(
        data=df.loc[rows].values,
        column_labels=columns,
        row_labels=rows,
        color_threshold={
            'row': 250,
            'col': 700
        },
        hidden_labels='row',
        height=800,
        width=700
    ))


if __name__ == '__main__':
    app.run_server(debug=True)
