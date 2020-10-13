
from dash_canvas import DashCanvas
import dash
from dash.dependencies import Input, Output, State
import dash_html_components as html
import dash_core_components as dcc
import dash_daq as daq

filename = 'https://www.publicdomainpictures.net/pictures/60000/nahled/flower-outline-coloring-page.jpg'
canvas_width = 300

app = dash.Dash(__name__)

app.layout = html.Div([
        html.Div([
            DashCanvas(
                id='canvas-color',
                width=canvas_width,
                filename=filename,
                hide_buttons=['line', 'zoom', 'pan'],
                )
                ], className="six columns"),
        html.Div([
            html.H6(children=['Brush width']),
            dcc.Slider(
                id='bg-width-slider',
                min=2,
                max=40,
                step=1,
                value=5
            ),
            daq.ColorPicker(
                id='color-picker',
                label='Brush color',
                value=dict(hex='#119DFF')
        ),
        ], className="three columns"),
        ])


@app.callback(Output('canvas-color', 'lineColor'),
            [Input('color-picker', 'value')])
def update_canvas_linewidth(value):
    if isinstance(value, dict):
        return value['hex']
    else:
        return value


@app.callback(Output('canvas-color', 'lineWidth'),
            [Input('bg-width-slider', 'value')])
def update_canvas_linewidth(value):
    return value

if __name__ == '__main__':
    app.run_server(debug=True)
