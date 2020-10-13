# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div([
    html.H1('Upload Component'),
    rc.Markdown('''
    The Dash upload component allows your app's viewers to upload files,
    like excel spreadsheets or images, into your application.
    Your Dash app can access the contents of an upload by listening to
    the `contents` property of the `dcc.Upload` component.

    `contents` is a base64 encoded string that contains the files contents,
    no matter what type of file: text files, images, zip files,
    excel spreadsheets, etc.

    '''),

    rc.Syntax(examples['upload-datafile.py'][0], summary=rc.Markdown('''
        Here's an example that parses CSV or Excel files and displays
        the results in a table. Note that this example uses the
        `DataTable` from the
        [dash-table](https://github.com/plotly/dash-table)
        project.
    ''')),

    rc.Example(examples['upload-datafile.py'][1]),

    html.Hr(),

    rc.Syntax(examples['upload-image.py'][0], summary=rc.Markdown('''
        This next example responds to image uploads by displaying them
        in the app with the `html.Img` component.
    ''')),
    rc.Example(examples['upload-image.py'][1]),

    rc.Syntax(examples['upload-gallery.py'][0], summary=rc.Markdown('''
        The `children` attribute of the `Upload` component accepts any
        Dash component. Clicking on the children element will trigger the
        upload action, as will dragging and dropping files.
        Here are a few different ways that you could style the upload
        component using standard dash components.
    ''')),
    rc.Example(examples['upload-gallery.py'][1]),

    html.Hr(),

    html.H2('dcc.Upload Component Properties'),
    rc.ComponentReference('Upload')
])
