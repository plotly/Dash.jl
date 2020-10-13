import pandas as pd

import dash
import dash_bio as dashbio
import dash_html_components as html
import dash_core_components as dcc


external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

df = pd.read_csv(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'manhattan_data.csv'
)

app.layout = html.Div([
    'Threshold value',
    dcc.Slider(
        id='manhattanplot-input',
        min=1,
        max=10,
        marks={
            i: {'label': str(i)} for i in range(10)
        },
        value=6
    ),
    html.Br(),
    html.Div(
        dcc.Graph(
            id='my-dashbio-manhattanplot',
            figure=dashbio.ManhattanPlot(
                dataframe=df
            )
        )
    )
])


@app.callback(
    dash.dependencies.Output('my-dashbio-manhattanplot', 'figure'),
    [dash.dependencies.Input('manhattanplot-input', 'value')]
)
def update_manhattanplot(threshold):

    return dashbio.ManhattanPlot(
        dataframe=df,
        genomewideline_value=threshold
    )


if __name__ == '__main__':
    app.run_server(debug=True)
