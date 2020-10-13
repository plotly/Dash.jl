import dash
import dash_html_components as html
from dash_canvas import DashCanvas
import numpy as np

app = dash.Dash(__name__)

filename = 'https://raw.githubusercontent.com/plotly/datasets/master/mitochondria.jpg'
canvas_width = 500


app.layout = html.Div([
    DashCanvas(id='canvas_image',
               tool='line',
               lineWidth=5,
               lineColor='red',
               filename=filename,
               width=canvas_width)
    ])


if __name__ == '__main__':
    app.run_server(debug=True)
