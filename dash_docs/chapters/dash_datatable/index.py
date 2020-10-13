import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd

from dash_docs.reusable_components import Section, Chapter
from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

preamble = html.Div([

    rc.Markdown('''
    # Dash DataTable

    '''),

    html.Iframe(
        src="https://ghbtns.com/github-btn.html?user=plotly&repo=dash-table&type=star&count=true&size=large",
        width="160px",
        height="30px",
        style={'border': 'none'}
    ),

    rc.Markdown('''
    > Dash DataTable is an interactive table component designed for
    > viewing, editing, and exploring large datasets.
    >
    > DataTable is rendered with standard, semantic HTML `<table/>` markup,
    > which makes it accessible, responsive, and easy to style.
    >
    > This component was written from scratch in React.js specifically
    > for the Dash community. Its API was designed to be ergonomic
    > and its behavior is completely customizable through its properties.
    >
    > 7 months in the making, this is the most complex Dash
    > component that Plotly has written, all from the ground-up
    > using React and TypeScript. DataTable was designed with a
    > featureset that allows that Dash users to create complex,
    > spreadsheet driven applications with no compromises.
    > We're excited to continue to work with users and companies
    > that [invest in DataTable's future](https://plotly.com/products/consulting-and-oem/).
    >
    > With `dash-table v4.0.0` - included in `dash v1.0.0` and released on
    > June 20, 2019 - we consider the API stable. We don't expect any
    > breaking changes any time soon, but if there are they will be
    > accompanied by a new major version of dash. If you've been using
    > DataTable with `dash v0.x` / `dash-table v3.x`, check out the
    > [Dash 1.0 Migration Guide](/dash-1-0-migration) for the full list of
    > changes.
    >
    > Otherwise, check out DataTable in the docs below.
    > If you make something cool with it, we'd love to see it! Share it
    > on the [community forum](https://community.plotly.com/t/show-and-tell-community-thread/7554)!
    >
    > -- chriddyp
    '''),

    Section('Quickstart', [
        rc.Markdown(
            '''
            ```shell
            pip install dash=={}
            ```
            '''.format(dash.__version__),
            style=styles.code_container
        ),

        rc.Markdown(
            examples['simple.py'][0],
            style=styles.code_container
        ),

        html.Div(examples['simple.py'][1], className='example-container'),

    ]),

    Section('User Guide', []),
])
