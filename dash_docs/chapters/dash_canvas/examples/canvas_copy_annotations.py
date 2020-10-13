import numpy as np
from skimage import io
import dash
from dash.exceptions import PreventUpdate
from dash.dependencies import Input, Output, State
import dash_html_components as html
from dash_canvas import DashCanvas
from dash_canvas.utils import array_to_data_url, parse_jsonstring

app = dash.Dash(__name__)

filename = 'https://raw.githubusercontent.com/plotly/datasets/master/mitochondria.jpg'

canvas_width = 300

app.layout = html.Div([
    html.H6('Draw on image and press Save to show annotations geometry'),
    html.Div([
    DashCanvas(id='canvas',
               lineWidth=5,
               filename=filename,
               width=canvas_width,
               ),
    ], className="five columns"),
    html.Div([
    html.Img(id='my-image', width=300),
    ], className="five columns"),
    ])


@app.callback(Output('my-image', 'src'),
              [Input('canvas', 'json_data')])
def update_data(string):
    if string:
        mask = parse_jsonstring(string, io.imread(filename, as_gray=True).shape)
    else:
        raise PreventUpdate
    return array_to_data_url((255 * mask).astype(np.uint8))


if __name__ == '__main__':
    app.run_server(debug=True)
