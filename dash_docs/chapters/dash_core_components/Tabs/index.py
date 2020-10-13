# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

tabs_styled_with_classes_css = tools.read_file('assets/tabs-styled-with-classes.css')


layout = html.Div(children=[
    html.H1('Tabs Examples and Reference'),
    rc.Markdown('''
    The `dcc.Tabs` and `dcc.Tab` components can be used to create tabbed sections in your app.
    The `dcc.Tab` component controls the style and value of the individual tab
    and the `dcc.Tabs` component hold a collection of `dcc.Tab` components.
    '''),

    html.H2('Method 1. Content as Callback'),
    rc.Markdown('''
    Attach a callback to the Tabs `value` prop and update a container's `children`
    property in your callback.
    '''),
    rc.Markdown(
        examples['tabs_callback.py'][0],
        style=styles.code_container
    ),
    html.Div(examples['tabs_callback.py'][1], className='example-container'),
    rc.Markdown('''
    In the example above, our callback contains all of the content. In practice,
    we'll keep the tab's content in separate files and import the data.
    For an example, see the <dccLink children="URLs and Multi-Page App Tutorial" href="/urls"/>.
    '''),

    html.H2('Method 2. Content as Tab Children'),
    rc.Markdown('''
    Instead of displaying the content through a callback, you can embed the content
    directly as the `children` property in the `Tab` component:
    '''),

    rc.Markdown(
        examples['tabs_simple.py'][0],
        style=styles.code_container
    ),
    html.Div(examples['tabs_simple.py'][1], className='example-container'),
    rc.Markdown('''
    Note that this method has a drawback: it requires that you compute the children property for each individual
    tab _upfront_ and send all of the tab's content over the network _at once_.
    The callback method allows you to compute the tab's content _on the fly_
    (that is, when the tab is clicked).
    '''),

    html.H2('Styling the Tabs component with CSS Classes'),
    rc.Markdown('''
    Styling the Tabs (and Tab) component can either be done using CSS classes by providing your own to the `className` property:
    '''),

    rc.Markdown(
        examples['tabs_styled_with_classes.py'][0],
        style=styles.code_container
    ),
    html.Div(examples['tabs_styled_with_classes.py'][1], className='example-container'),

    html.Br(),

    rc.Markdown('''
    Notice how the container of the Tabs can be styled as well by supplying a class to the `parent_className` prop, which we use here to draw a border below it, positioning the actual Tabs (with padding) more in the center.
    We also added `display: flex` and `justify-content: center` to the regular `Tab` components, so that labels with multiple lines will not break the flow of the text.

    The corresponding CSS file (`assets/tabs.css`) looks like this.
    Save the file in an `assets` folder (it can be named anything you want).
    Dash will automatically include this CSS when the app is loaded.
    <dccLink
        children="Learn more about including CSS in your app"
        href="/external-resources"
    />.
    '''),

    rc.Markdown(
        '```css\n' + tabs_styled_with_classes_css + '\n```',
        style=styles.code_container
    ),

    html.Br(),

    html.H2('Styling Tabs with Inline Styles'),
    rc.Markdown('''
    An alternative to providing CSS classes is to provide style dictionaries directly:
    '''),

    rc.Markdown(
        examples['tabs_styled_with_inline.py'][0],
        style=styles.code_container
    ),
    html.Div(examples['tabs_styled_with_inline.py'][1], className='example-container'),

    html.Br(),

    rc.Markdown('''
    Lastly, you can set the colors of the Tabs components in the `color` prop, by specifying the "border", "primary", and "background" colors in a dict. Make sure you set them
    all, if you're using them!
    '''),

    rc.Markdown(
        examples['tabs_styled_with_props.py'][0],
        style=styles.code_container
    ),
    html.Div(examples['tabs_styled_with_props.py'][1], className='example-container'),

    html.Hr(),

    html.H2('dcc.Tabs properties'),
    rc.ComponentReference('Tabs'),
    html.Hr(),
    html.H2('dcc.Tab properties'),
    rc.ComponentReference('Tab')
])
