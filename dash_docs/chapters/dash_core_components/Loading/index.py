# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div([
    html.H1('dcc.Loading Component Documentation'),

    rc.Markdown('''
    Here’s a simple example that wraps the outputs for a couple of `Input`
    components in the `Loading` component.
    As you can see, you can define the type of spinner you would like to show
    (refer to the reference table below for all possible types of spinners).
    You can modify other attributes as well, such as `fullscreen=True`
    if you would like the spinner to be displayed fullscreen.
    Notice that, the Loading component traverses all
    of its children to find a loading state, as demonstrated in the
    second callback, so that even nested children will get picked up.
    '''),

    rc.Syntax(examples['loading_component.py'][0]),
    rc.Example(examples['loading_component.py'][1]),
    rc.Markdown('''
    Please also check out <dccLink href="/loading-states" children="this section on loading states"/> if you want a more customizable experience.
    '''),
    html.H2('dcc.Loading Properties'),
    rc.ComponentReference('Loading')
])
