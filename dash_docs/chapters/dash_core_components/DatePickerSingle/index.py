# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)


layout = html.Div(children=[
    html.H1("DatePickerSingle Examples and Reference"),
    html.Hr(),
    html.H3("Simple DatePickerSingle Example"),
    rc.Markdown("This is a simple example of a `DatePickerSingle` \
        component tied to a callback. You can use either date objects \
        (`datetime.date` or `datetime.datetime`) or strings in the form \
        `YYYY-MM-DD` to provide dates to Dash components. Strings are \
        preferred because that's the form dates take as callback arguments. \
        Be aware that any time information included in a datetime object \
        or string will be ignored. The `min_date_allowed` and `max_date_allowed` \
        properties define the minimum and maximum selectable dates on the calendar \
        while `initial_visible_month` defines the calendar month that is \
        first displayed when the `DatePickerSingle` component is opened."),
    rc.Markdown(
        examples['date_picker_single.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['date_picker_single.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),

    html.H3('Month and Display Format'),
    rc.Markdown("The `display_format` property \
                 determines how selected dates are displayed \
                 in the `DatePickerSingle` component. The `month_format` \
                 property determines how calendar headers are displayed when \
                 the calendar is opened."),
    html.P("Both of these properties are configured through \
            strings that utilize a combination of any \
            of the following tokens."),
    html.Table([
        html.Tr([
            html.Th('String Token', style={'text-align': 'left', 'width': '20%'}),
            html.Th('Example', style={'text-align': 'left', 'width': '20%'}),
            html.Th('Description', style={'text-align': 'left', 'width': '60%'})
        ]),
        html.Tr([
            html.Td(rc.Markdown('`YYYY`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`2014`'), style={'text-align': 'left'}),
            html.Td('4 or 2 digit year')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`YY`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`14`'), style={'text-align': 'left'}),
            html.Td('2 digit year')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`Y`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`-25`'), style={'text-align': 'left'}),
            html.Td('Year with any number of digits and sign')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`Q`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`1..4`'), style={'text-align': 'left'}),
            html.Td('Quarter of year. Sets month to first month in quarter.')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`M MM`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`1..12`'), style={'text-align': 'left'}),
            html.Td('Month number')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`MMM MMMM`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`Jan..December`'), style={'text-align': 'left'}),
            html.Td('Month name')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`D DD`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`1..31`'), style={'text-align': 'left'}),
            html.Td('Day of month')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`Do`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`1st..31st`'), style={'text-align': 'left'}),
            html.Td('Day of month with ordinal')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`DDD DDDD`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`1..365`'), style={'text-align': 'left'}),
            html.Td('Day of year')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`X`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`1410715640.579`'), style={'text-align': 'left'}),
            html.Td('Unix timestamp')
        ]),
        html.Tr([
            html.Td(rc.Markdown('`x`'), style={'text-align': 'left'}),
            html.Td(rc.Markdown('`1410715640579`'), style={'text-align': 'left'}),
            html.Td('Unix ms timestamp')
        ]),
    ]),

    html.Br(),

    html.H3("Display Format Examples"),
    rc.Markdown("You can utilize any permutation of the string tokens \
                 shown in the table above to change how selected dates are \
                 displayed in the `DatePickerSingle` component."),
    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    date='2017-06-21',
    display_format='MMM Do, YY'
)'''),

    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    date=dt(2017,6,21),
    display_format='M-D-Y-Q',
)'''),

    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    date=dt(2017,6,21),
    display_format='MMMM Y, DD'
)'''),

    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    date=dt(2017,6,21),
    display_format='X',
)''', style=styles.code_container),
    html.Br(),
    html.H3("Month Format Examples"),
    rc.Markdown("Similar to the `display_format`, you can set `month_format` \
                 to any permutation of the string tokens \
                 shown in the table above to change how calendar titles \
                 are displayed in the `DatePickerSingle` component."),
    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    month_format='MMM Do, YY',
    placeholder='MMM Do, YY',
    date=dt(2017,6,21)
)'''),
    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    month_format='M-D-Y-Q',
    placeholder='M-D-Y-Q',
    date=dt(2017,6,21)
)'''),

    rc.ComponentBlock('''import dash_core_components as dcc
import datetime

dcc.DatePickerSingle(
    month_format='MMMM Y',
    placeholder='MMMM Y',
    date=datetime.date(2020,2,29)
)'''),

    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    month_format='X',
    placeholder='X',
    date=dt(2017,6,21,0,0,0,0)
)''', style=styles.code_container),
    html.Hr(),
    html.H3("Vertical Calendar and Placeholder Text"),
    rc.Markdown("The `DatePickerSingle` component can be rendered in two \
                  orientations, either horizontally or vertically. \
                  If `calendar_orientation` is set to `'vertical'`, it will \
                  be rendered vertically and will default to `'horizontal'` \
                  if not defined."),
    rc.Markdown("The `placeholder` defines the grey default \
                  text defined in the calendar input boxes when no date is \
                  selected."),
    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    calendar_orientation='vertical',
    placeholder='Select a date',
    date=dt(2017,6,21)
)'''),

    html.Hr(),

    html.H3("Calendar Clear and Portals"),
    rc.Markdown("When the `clearable` property is set to `True` \
                  the component will be rendered with a small 'x' \
                  that will remove all selected dates when selected."),
    rc.Markdown("The `DatePickerSingle` component supports two different \
                  portal types, one being a full screen portal \
                  (`with_full_screen_portal`) and another being a simple \
                  screen overlay, like the one shown below (`with_portal`)."),
    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    clearable=True,
    with_portal=True,
    date=dt(2017,6,21)
)'''),

    html.Hr(),

    html.H3("Right to Left Calendars and First Day of Week"),
    rc.Markdown("When the `is_RTL` property is set to `True` \
                  the calendar will be rendered from right to left."),
    rc.Markdown("The `first_day_of_week` property allows you to \
                  define which day of the week will be set as the first \
                  day of the week. In the example below, Tuesday is \
                  the first day of the week."),
    rc.ComponentBlock('''import dash_core_components as dcc
from datetime import datetime as dt

dcc.DatePickerSingle(
    is_RTL=True,
    first_day_of_week=3,
    date=dt(2017,6,21)
)'''),

    html.Hr(),
    html.H3('DatePickerSingle Properties'),
    rc.ComponentReference('DatePickerSingle')
])
