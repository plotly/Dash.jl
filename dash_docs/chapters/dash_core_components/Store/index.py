# -*- coding: utf-8 -*-
import dash_html_components as html

from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div([
    html.H1('dcc.Store'),
    rc.Markdown('''
    The `dcc.Store` component is used to store JSON data in the browser.
    '''),
    html.H2('Store clicks example'),
    rc.Syntax(examples['store_clicks.py'][0]),
    rc.Example(examples['store_clicks.py'][1]),

    html.H2('Share data between callbacks'),

    rc.Syntax(examples['store_share.py'][0]),
    rc.Example(examples['store_share.py'][1]),

    rc.Markdown('''
    ## Storage Limitations

    - The maximum browser [storage space](https://demo.agektmr.com/storage/) is determined by the following factors:
        - Mobile or laptop
        - The browser, under which a sophisticated algorithm is implemented within *Quota Management*
        - Storage encoding where UTF-16 can end up saving only half of the size of UTF-8
        - It's generally safe to store up to 2MB in most environments, and 5~10MB in most desktop-only applications.
    - `modified_timestamp` is read only.

    ## Retrieving the initial store data

    If you use the `data` prop as an output, you cannot get the
    initial data on load with the `data` prop. To counter this,
    you can use the `modified_timestamp` as `Input` and the `data` as `State`.
    '''),

    html.H2('dcc.Store Properties'),
    rc.ComponentReference('Store'),
])
