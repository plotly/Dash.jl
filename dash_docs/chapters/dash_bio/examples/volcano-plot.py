import pandas as pd

import dash
import dash_bio as dashbio
import dash_html_components as html
import dash_core_components as dcc


external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

df = pd.read_csv(
    'https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/' +
    'volcano_data1.csv'
)

app.layout = html.Div([
    'Effect sizes',
    dcc.RangeSlider(
        id='volcanoplot-input',
        min=-3,
        max=3,
        step=0.05,
        marks={
            i: {'label': str(i)} for i in range(-3, 3)
        },
        value=[-0.5, 1]
    ),
    html.Br(),
    html.Div(
        dcc.Graph(
            id='my-dashbio-volcanoplot',
            figure=dashbio.VolcanoPlot(
                dataframe=df
            )
        )
    )
])


@app.callback(
    dash.dependencies.Output('my-dashbio-volcanoplot', 'figure'),
    [dash.dependencies.Input('volcanoplot-input', 'value')]
)
def update_volcanoplot(effects):

    return dashbio.VolcanoPlot(
        dataframe=df,
        genomewideline_value=2.5,
        effect_size_line=effects
    )


if __name__ == '__main__':
    app.run_server(debug=True)
