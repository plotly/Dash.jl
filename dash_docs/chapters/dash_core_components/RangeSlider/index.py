# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div(children=[
    html.H1("RangeSlider Examples and Reference"),
    html.H3('Simple RangeSlider Example'),
    html.P("An example of a basic RangeSlider tied to a callback."),
    rc.Markdown(
        examples['rangeslider.py'][0],
        style=styles.code_container,
    ),

    html.Div(
        examples['rangeslider.py'][1],
        className='example-container',
        style={'overflow': 'hidden'}),

    html.H3('Marks and Steps'),
    rc.Markdown("If slider `marks` are defined and `step` is set to `None` \
                 then the slider will only be able to select values that \
                 have been predefined by the `marks`. \
                 Note that the default is `step=1`, so you must explicitly \
                 specify `None` to get this behavior."),
    rc.ComponentBlock('''import dash_core_components as dcc

dcc.RangeSlider(
    min=0,
    max=10,
    step=None,
    marks={
        0: '0 °F',
        3: '3 °F',
        5: '5 °F',
        7.65: '7.65 °F',
        10: '10 °F'
    },
    value=[3, 7.65]
)''', style=styles.code_container),

    html.H3('Included and Styling Marks'),
    rc.Markdown("By default, `included=True`, meaning the rail trailing the \
                 handle will be highlighted. To have the handle act as a \
                 discrete value set `included=False`. To style `marks`, \
                 include a style css attribute alongside the key value."),
    rc.ComponentBlock('''import dash_core_components as dcc

# RangeSlider has included=True by default
dcc.RangeSlider(
    min=0,
    max=100,
    value=[10, 65],
    marks={
        0: {'label': '0°C', 'style': {'color': '#77b0b1'}},
        26: {'label': '26°C'},
        37: {'label': '37°C'},
        100: {'label': '100°C', 'style': {'color': '#f50'}}
    }
)'''),

    rc.ComponentBlock('''import dash_core_components as dcc

dcc.RangeSlider(
    min=0,
    max=100,
    value=[10, 65],
    marks={
        0: {'label': '0°C', 'style': {'color': '#77b0b1'}},
        26: {'label': '26°C'},
        37: {'label': '37°C'},
        100: {'label': '100°C', 'style': {'color': '#f50'}}
    },
    included=False
)''', style=styles.code_container),

    html.H3('Multiple Handles'),
    rc.Markdown('To create multiple handles \
                  just define more values for `value`!'),
    rc.ComponentBlock('''import dash_core_components as dcc

dcc.RangeSlider(
    min=0,
    max=30,
    value=[1, 3, 4, 5, 12, 17]
)
    ''', style=styles.code_container),
    html.H3('Pushable Handles'),
    rc.Markdown("The `pushable` property is either a `boolean` or a numerical value. \
                The numerical value determines the minimum distance between \
                the handles. Try moving the handles around!"),
    rc.ComponentBlock('''import dash_core_components as dcc
dcc.RangeSlider(
    min=0,
    max=30,
    value=[8, 10, 15, 17, 20],
    pushable=2
)
    ''', style=styles.code_container),

    html.H3('Crossing Handles'),
    rc.Markdown("If `allowCross=False`, the handles will not be allowed to\
                  cross over each other"),
    rc.ComponentBlock('''import dash_core_components as dcc

dcc.RangeSlider(
    min=0,
    max=30,
    value=[10, 15],
    allowCross=False
)
    ''', style=styles.code_container),

    html.H3('Non-Linear Slider and Updatemode'),
    rc.Markdown("Create a logarithmic slider by setting `marks`\
                 to be logarithmic and adjusting the slider's output \
                 `value` in the callbacks. The `updatemode` property \
                 allows us to determine when we want a callback to be \
                 triggered. The following example has `updatemode='drag'` \
                 which means a callback is triggered everytime the handle \
                 is moved. \
                 Contrast the callback output with the first example on this \
                 page to see the difference."),
    rc.Markdown(
        examples['rangeslider_nonlinear.py'][0],
        style=styles.code_container,
    ),
    html.Div(examples['rangeslider_nonlinear.py'][1],
             className='example-container',
             style={'overflow': 'hidden', 'padding': '20px'}),

    html.H3("RangeSlider Properties"),
    rc.ComponentReference('RangeSlider')
])
