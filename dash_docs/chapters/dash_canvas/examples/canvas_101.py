import dash
import dash_html_components as html
from dash_canvas import DashCanvas

app = dash.Dash(__name__)
app.config.suppress_callback_exceptions = True

app.layout = html.Div([
    html.H5('Press down the left mouse button and draw inside the canvas'),
    DashCanvas(id='canvas_101')
    ])


if __name__ == '__main__':
    app.run_server(debug=True)
