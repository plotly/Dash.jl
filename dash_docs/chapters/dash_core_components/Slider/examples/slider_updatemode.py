import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import dash

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

# Use the following function when accessing the value of 'my-slider'
# in callbacks to transform the output value to logarithmic
def transform_value(value):
    return 10 ** value


app.layout = html.Div([
    dcc.Slider(
        id='slider-updatemode',
        marks={i: '{}'.format(10 ** i) for i in range(4)},
        max=3,
        value=2,
        step=0.01,
        updatemode='drag'
    ),
    html.Div(id='updatemode-output-container', style={'margin-top': 20})
])


@app.callback(Output('updatemode-output-container', 'children'),
              [Input('slider-updatemode', 'value')])
def display_value(value):
    return 'Linear Value: {} | \
            Log Value: {:0.2f}'.format(value, transform_value(value))


if __name__ == '__main__':
    app.run_server(debug=True)
