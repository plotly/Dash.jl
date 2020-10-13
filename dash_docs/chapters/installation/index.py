# -*- coding: utf-8 -*-
import dash
import dash_renderer
import dash_core_components as dcc
import dash_html_components as html
import dash_table
import dash_daq

import plotly

from dash_docs import styles, tools
from dash_docs import reusable_components as rc

layout = html.Div([

    rc.Markdown('''
    # Dash Installation

    In your terminal, install several dash libraries.
    These libraries are under active development,
    so install and upgrade frequently.
    Python 2 and 3 are supported.'''),

    rc.Markdown('''
    ```shell
    pip install dash=={}
    ```
    '''.format(
        dash.__version__,
        dash_daq.__version__
    ), style=styles.code_container),

    rc.Markdown('''
    > **Note**: starting with dash 0.37.0, dash automatically installs dash-renderer, dash-core-components,
    > dash-html-components, and dash-table, using known-compatible versions of each. You need not and
    > should not install these separately any longer, only dash itself.
    '''),

    html.Div([
        'Ready? Now, let\'s ',
        dcc.Link('make your first Dash app', href=tools.relpath('/layout')),
        '.'
    ]),

    html.Hr(),

    rc.Markdown('''
    > A quick note on checking your versions and on upgrading.
    > These docs are run using the versions listed above and these
    > versions should be the latest versions available.
    > To check which version that you have installed, you can run e.g.
    > ```
    > >>> import dash_core_components
    > >>> print(dash_core_components.__version__)
    > ```
    > To see the latest changes of any package, check the GitHub repo's CHANGELOG.md file:
    > - [dash & dash-renderer changelog](https://github.com/plotly/dash/blob/master/CHANGELOG.md)
    >   - `dash-renderer` is a separate package installed automatically with
    >     dash but its updates are included in the main dash changelog.
    >     These docs are using dash-renderer=={}.
    > - [dash-core-components changelog](https://github.com/plotly/dash-core-components/blob/master/CHANGELOG.md)
    > - [dash-html-components changelog](https://github.com/plotly/dash-html-components/blob/master/CHANGELOG.md)
    > - [dash-table changelog](https://github.com/plotly/dash-table/blob/master/CHANGELOG.md)
    > - [plotly changelog](https://github.com/plotly/plotly.py/blob/master/CHANGELOG.md)
    >   - the `plotly` package is also installed automatically with dash. It is
    >     the Python interface to the plotly.js graphing library, so is mainly
    >     used by dash-core-components, but it's also used by dash itself.
    >     These docs are using plotly=={}.
    >
    > All of these packages adhere to [semver](https://semver.org/).
    '''.format(dash_renderer.__version__, plotly.__version__))

])
