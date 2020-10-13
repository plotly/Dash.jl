import dash
from dash.dependencies import Input, Output
import dash_core_components as dcc
import dash_html_components as html

CITIES = ['Boston', 'London', 'Montreal']
NEIGHBORHOODS = {
    'Boston': ['Back Bay', 'Fenway', 'Jamaica Plain'],
    'London': ['Canary Wharf', 'Hackney', 'Kensington'],
    'Montreal': ['Le Plateau', 'Mile End', 'Rosemont']
}

app = dash.Dash(__name__)

app.layout = html.Div([
    'Choose a city:',
    dcc.Dropdown(
        id='persisted-city',
        value='Montreal',
        options=[{'label': v, 'value': v} for v in CITIES],
        persistence=True
    ),
    html.Br(),

    'correlated persistence - choose a neighborhood:',
    html.Div(dcc.Dropdown(id='neighborhood'), id='neighborhood-container'),
    html.Br(),
    html.Div(id='persisted-choices')
])


@app.callback(
    Output('neighborhood-container', 'children'),
    [Input('persisted-city', 'value')]
)
def set_neighborhood(city):
    neighborhoods = NEIGHBORHOODS[city]
    return dcc.Dropdown(
        id='neighborhood',
        value=neighborhoods[0],
        options=[{'label': v, 'value': v} for v in neighborhoods],
        persistence_type='session',
        persistence=city
    )


@app.callback(
    Output('persisted-choices', 'children'),
    [Input('persisted-city', 'value'), Input('neighborhood', 'value')]
)
def set_out(city, neighborhood):
    return 'You chose: {}, {}'.format(neighborhood, city)


if __name__ == '__main__':
    app.run_server(debug=True)
