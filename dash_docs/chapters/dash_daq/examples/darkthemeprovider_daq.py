import dash
from dash.dependencies import Input, Output
import dash_daq as daq
import dash_html_components as html


app = dash.Dash(__name__)

theme = {
    'dark': False,
    'detail': '#007439',
    'primary': '#00EA64', 
    'secondary': '#6E6E6E'
}

app.layout = html.Div(id='dark-theme-provider-demo', children=[
    html.Br(), 
    daq.ToggleSwitch(
        id='daq-light-dark-theme',
        label=['Light', 'Dark'],
        style={'width': '250px', 'margin': 'auto'}, 
        value=False
    ),
    html.Div(
        id='dark-theme-component-demo',
        children=[
            daq.DarkThemeProvider(theme=theme, children=
                                  daq.Knob(value=6))
        ],
        style={'display': 'block', 'margin-left': 'calc(50% - 110px)'}
    )
])


@app.callback(
    Output('dark-theme-component-demo', 'children'),
    [Input('daq-light-dark-theme', 'value')]
)
def turn_dark(dark_theme): 
    if(dark_theme):
        theme.update(
            dark=True
        )
    else:
        theme.update(
            dark=False
        )
    return daq.DarkThemeProvider(theme=theme, children=
                                 daq.Knob(value=6))


@app.callback(
    Output('dark-theme-provider-demo', 'style'),
    [Input('daq-light-dark-theme', 'value')]
)
def change_bg(dark_theme):
    if(dark_theme):
        return {'background-color': '#303030', 'color': 'white'}
    else:
        return {'background-color': 'white', 'color': 'black'}


if __name__ == '__main__':
    app.run_server(debug=True)
