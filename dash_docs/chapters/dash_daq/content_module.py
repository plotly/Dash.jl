# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html
import dash_daq as daq

from dash_docs import styles
from dash_docs import tools
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__, omit=['darkthemeprovider_daq.py'])


# BooleanSwitch
BooleanSwitch = html.Div(children=[
    html.H1('Boolean Switch Examples and Reference'),
    html.Hr(),
    html.H3('Default Boolean Switch'),
    html.P("An example of a default boolean switch without \
            any extra properties."),
    rc.Markdown(
        examples['boolean-switch.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['boolean-switch.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3('Color'),
    rc.Markdown("Set the color of the boolean switch with \
    `color=#<hex_value>`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.BooleanSwitch(
  on=True,
  color="#9B51E0",
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Label'),
    rc.Markdown("Set the label and label position using the `label` and `labelPosition` \
    properties."),
    rc.ComponentBlock('''import dash_daq as daq

daq.BooleanSwitch(
  on=True,
  label="Label",
  labelPosition="top"
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Vertical Switch'),
    rc.Markdown("Create a vertical oriented switch by setting `vertical=True`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.BooleanSwitch(
  on=True,
  label="Vertical",
  vertical=True
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Disabled Switch'),
    rc.Markdown("To disable the Boolean Switch set the property `disabled` to `True`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.BooleanSwitch(
  disabled=True,
  label="Disabled",
  labelPosition="bottom"
)''', style=styles.code_container),
    html.Hr(),
    html.H3("Boolean Switch Properties"),
    rc.ComponentReference('BooleanSwitch', lib=daq)
])

# ColorPicker
ColorPicker = html.Div(children=[
    html.H1('Color Picker Examples and Reference'),
    html.Hr(),
    html.H3('Default Color Picker'),
    html.P("An example of a default Color Picker without \
            any extra properties."),
    rc.Markdown(
        examples['color-picker.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['color-picker.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3('Size'),
    rc.Markdown("Set the size (width) of the color picker in pixels using the `size` property."),
    rc.ComponentBlock('''import dash_daq as daq

daq.ColorPicker(
  label="Small",
  size=164,
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Label'),
    rc.Markdown("Define the label and label position using the `label` and `labelPosition` \
    properties."),
    rc.ComponentBlock('''import dash_daq as daq

daq.ColorPicker(
  label="Label",
  labelPosition="bottom"
)''', style=styles.code_container),
    html.Hr(),
html.H3('Disabled'),
    rc.Markdown("To disable the Color Picker set `disabled` to `True`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.ColorPicker(
  label='Color Picker',
  disabled=True,
)''', style=styles.code_container),
    html.Hr(),
html.H3('Hex Colors'),
    rc.Markdown("Use hex values with the Color Picker by setting `value=dict(hex='#<hex_color>')`"),
    rc.ComponentBlock('''import dash_daq as daq

daq.ColorPicker(
  label='Color Picker',
  value=dict(hex="#0000FF"),
)''', style=styles.code_container),
    html.Hr(),
html.H3('RGB Colors'),
    rc.Markdown("Use RGB color values with the Color Picker by setting: \
    \n `value=(rgb=dict(r=<r_value>, g=<g_value>, b=<b_value>, a=<a_value>)`"),
    rc.ComponentBlock('''import dash_daq as daq

daq.ColorPicker(
label='Color Picker',
value=dict(rgb=dict(r=255, g=0, b=0, a=0))
)''', style=styles.code_container),
    html.Hr(),
    html.Hr(),
    html.H3("Color Picker Properties"),
    rc.ComponentReference('ColorPicker', lib=daq)
])

# Gauge
Gauge = html.Div(children=[
    html.H1('Gauge Examples and Reference'),
    html.Hr(),
    html.H3('Default Gauge'),
    html.P("An example of a default Gauge without \
            any extra properties."),
    rc.Markdown(
        examples['gauge.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['gauge.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3('Minimum and Maximum'),
    rc.Markdown("Specify the minimum and maximum values of the gauge, using the `min` and `max` properties. If \
    the scale is logarithmic the minimum and maximum will represent an exponent."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Gauge(
    value=5,
    label='Default',
    max=20,
    min=0,
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Current Value and Units'),
    rc.Markdown("Show the current value of the gauge and the units with `showCurrentValue=True` \
    and `units=<units>`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Gauge(
    showCurrentValue=True,
    units="MPH",
    value=5,
    label='Default',
    max=10,
    min=0,
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Logarithmic Gauge'),
    rc.Markdown("To set the scale of the gauge to logarithmic use the property `logarithmic=True`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Gauge(
    logarithmic=True,
    value=5,
    label='Default',
    max=10,
    min=0,
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Color'),
    rc.Markdown("Set the color of the gauge by using the property `color=<hex_color>`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Gauge(
    color="#9B51E0",
    value=2,
    label='Default',
    max=5,
    min=0,
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Color Gradient'),
    rc.Markdown("Apply a color gradient to the gauge with the property: \
    \n `color={'gradient':True,'ranges':{'<color>':[<value>, <value>],'<color>':[<value>, <value>],'<color>':[<value>, <value>]}}`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Gauge(
    color={"gradient":True,"ranges":{"green":[0,6],"yellow":[6,8],"red":[8,10]}},
    value=2,
    label='Default',
    max=10,
    min=0,
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Size'),
    rc.Markdown("Adjust the size of the gauge in pixels `size=200`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Gauge(
    size=200,
    value=2,
    label='Default',

)''', style=styles.code_container),
    html.Hr(),
    html.H3('Scale'),
    rc.Markdown("Modify where the scale starts, the label interval, and actual interval \
    with the `scale` property."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Gauge(
  label='Scale',
  scale={'start': 0, 'interval': 3, 'labelInterval': 2},
  value=3,
  min=0,
  max=24,
)''' , style=styles.code_container),
    html.Hr(),
    html.H3("Gauge Properties"),
    rc.ComponentReference('Gauge', lib=daq)
])

# Graduated Bar
GraduatedBar = html.Div(children=[
    html.H1('Graduated bar Examples and Reference'),
    html.Hr(),
    html.H3('Default Graduated bar'),
    rc.Markdown("An example of a default Graduated bar without \
            any extra properties."),
    rc.Markdown(
        examples['graduated-bar.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['graduated-bar.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),
    html.Hr(),
    html.H3('Orientation'),
    rc.Markdown("Change the orientation of the bar to vertical `vertical=True`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.GraduatedBar(
    vertical=True,
    value=10
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Size'),
    rc.Markdown("Manually adjust the size of the bar in pixels with `size`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.GraduatedBar(
    size=200,
    value=10
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Max'),
    rc.Markdown("Manually set a maximum value with `max`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.GraduatedBar(
    max=100,
    value=50
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Step'),
    rc.Markdown("Manually set the step size of each bar with `step`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.GraduatedBar(
    step=2,
    max=100,
    value=50
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Show Current Value'),
    rc.Markdown("Display the current value of the graduated bar with `showCurrentValue=True`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.GraduatedBar(
    showCurrentValue=True,
    max=100,
    value=38
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Color Range'),
    rc.Markdown("Set a color range with:  \
    \n `color={'ranges':{'<color>':[<value>, <value>],'<color>':[<value>, <value>],'<color>':[<value>, <value>]}}`"),
    rc.ComponentBlock('''import dash_daq as daq

daq.GraduatedBar(
    color={"ranges":{"green":[0,4],"yellow":[4,7],"red":[7,10]}},
    showCurrentValue=True,
    value=10
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Color Gradient'),
    rc.Markdown("Set a color gradient with: \
    \n `color={'gradient':True,'ranges':{'<color>':[<value>, <value>],'<color>':[<value>, <value>],'<color>':[<value>, <value>]}}`"),
    rc.ComponentBlock('''import dash_daq as daq

daq.GraduatedBar(
    color={"gradient":True,"ranges":{"green":[0,4],"yellow":[4,7],"red":[7,10]}},
    showCurrentValue=True,
    value=10
)''', style=styles.code_container),
    html.Hr(),
    html.H3("Graduated Bar Properties"),
    rc.ComponentReference('GraduatedBar', lib=daq)
])

# Indicator
Indicator = html.Div(children=[
    html.H1('Indicator Examples and Reference'),
    html.Hr(),
    html.H3('Default Indicator'),
    rc.Markdown("An example of a default Indicator without \
        any extra properties."),
    rc.Markdown(
        examples['indicator.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['indicator.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3('Label'),
    rc.Markdown(
        "Define the label and label orientation with `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Indicator(
  label="Label",
  labelPosition="bottom",
  value=True
)''', style=styles.code_container),
    html.H3('Boolean Indicator Off'),
    rc.Markdown("A boolean indicator set to off `value=False`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Indicator(
  label="Off",
  value=False
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Square'),
    rc.Markdown("Create a square boolean indicator by setting the \
    `width` and `height` to the same value."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Indicator(
  label="Square",
  width=16,
  height=16
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Color'),
    rc.Markdown(
        "Define the color of the boolean indicator with `color='#<color>'`"),
    rc.ComponentBlock('''import dash_daq as daq

daq.Indicator(
  label="Purple",
  color="#551A8B",
  value=True
)''', style=styles.code_container),
    html.Hr(),
    html.H3("Indicator Properties"),
    rc.ComponentReference('Indicator', lib=daq)
])

# Joystick
Joystick = html.Div(children=[
    html.H1('Joystick Examples and Reference'),
    html.Hr(),
    html.H3('Default Joystick'),
    rc.Markdown("An example of a default Joystick without \
    any extra properties."),
    rc.Markdown(
        examples['joystick.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['joystick.py'][1],
        style={'overflow=x': 'initial'}
    ),

    html.Hr(),
    html.H3('Label'),
    rc.Markdown(
        "Change the label and label orientation with `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Joystick(
  label="Label",
  labelPosition="bottom"
)''', style=styles.code_container),

    html.Hr(),
    html.H3('Size'),
    rc.Markdown(
        "Change the size of the joystick with `size`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Joystick(
  size=250
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Joystick Properties'),
    rc.ComponentReference('Joystick', lib=daq)
])

# Knob
Knob = html.Div(children=[
    html.H1('Knob Examples and Reference'),
    html.Hr(),
    html.H3('Default Knob'),
    rc.Markdown("An example of a default Knob without \
            any extra properties."),
    rc.Markdown(
        examples['knob.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['knob.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3('Size'),
    rc.Markdown("Set the size(diameter) of the knob in pixels with `size`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Knob(
    size=140,
    value=3
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Max'),
    rc.Markdown("Set the maximum value of the knob using `max`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Knob(
    max=100,
    value=3
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Color Ranges'),
    rc.Markdown("Control color ranges with: \
    \n `color={'ranges':{'<color>':[<value>,<value>],'<color>':[<value>,<value>], '<color>':[<value>,<value>]}}`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Knob(
  label="Color Ranges",
  value=3,
  color={"ranges":{"green":[0,5],"yellow":[5,9],"red":[9,10]}}
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Color Gradient'),
    rc.Markdown("Set up a color gradient with: \
    \n `color={'gradient':True,'ranges':{'<color>':[<value>,<value>],'<color>':[<value>,<value>], '<color>':[<value>,<value>]}}`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Knob(
  label="Gradient Ranges",
  value=7,
  color={"gradient":True,"ranges":{"green":[0,5],"yellow":[5,9],"red":[9,10]}}
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Scale'),
    rc.Markdown("Adjust the scale interval, label interval, \
    and start of the scale with `scale`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Knob(
  label="Scale",
  value=7,
  max=18,
  scale={'start':0, 'labelInterval': 3, 'interval': 3}
)''', style=styles.code_container),
    html.Hr(),
    html.H3("Knob Properties"),
    rc.ComponentReference('Knob', lib=daq)
])

# LED Display
LEDDisplay = html.Div(children=[
    html.H1('LED display Examples and Reference'),
    html.Hr(),
    html.H3('Default LED display'),
    rc.Markdown("An example of a default LED display without \
            any extra properties."),
    rc.Markdown(
        examples['LED-display.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['LED-display.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3('Label'),
    rc.Markdown("Set the label and label position with \
    `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.LEDDisplay(
    label="Label",
    labelPosition='bottom',
    value='12:34'
)''', style=styles.code_container),
    html.H3('Size'),
    rc.Markdown("Adjust the size of the LED display with `size`"),
    rc.ComponentBlock('''import dash_daq as daq

daq.LEDDisplay(
    label="Large",
    value="9:34",
    size=64,
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Color'),
    rc.Markdown("Adjust the color of the LED display with `color=#<hex_color>`"),
    rc.ComponentBlock('''import dash_daq as daq

daq.LEDDisplay(
    label="color",
    value='1.001',
    color="#FF5E5E"
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Background Color'),
    rc.Markdown("Adjust the background color of the LED display using: \
    \n `backgroundColor=#<hex_color>`"),
    rc.ComponentBlock('''import dash_daq as daq

daq.LEDDisplay(
    label="color",
    value='1.001',
    backgroundColor="#FF5E5E"
)''', style=styles.code_container),
    html.Hr(),
    html.H3("LED Display Properties"),
    rc.ComponentReference('LEDDisplay', lib=daq)
])

# Numeric Input
NumericInput = html.Div(children=[
    html.H1('Numeric Input Examples and Reference'),
    html.Hr(),
    html.H3('Default Numeric Input'),
    rc.Markdown("An example of a default numeric input without \
            any extra properties."),
    rc.Markdown(
        examples['numeric-input.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['numeric-input.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),
    html.Hr(),
    html.H3('Label'),
    rc.Markdown("Set the label and label position with \
    `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.NumericInput(
    label='Label',
    labelPosition='bottom',
    value=10,
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Size'),
    rc.Markdown("Extend the size with `size`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.NumericInput(
    value=10,
    size=120
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Max and Min'),
    rc.Markdown("Set the minimum and maximum bounds with `min` and `max`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.NumericInput(
    min=0,
    max=100,
    value=20
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Disable'),
    rc.Markdown("Disable the numeric input by setting `disabled=True`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.NumericInput(
    disabled=True,
    min=0,
    max=10,
    value=2
)''', style=styles.code_container),
    html.Hr(),
    html.Hr(),
    html.H3("Numeric Input Properties"),
    rc.ComponentReference('NumericInput', lib=daq)
])

# Power Button
PowerButton = html.Div(children=[
    html.H1('Power Button Examples and Reference'),
    html.Hr(),
    html.H3('Default Power Button'),
    rc.Markdown("An example of a default power button without \
            any extra properties."),
    rc.Markdown(
        examples['power-button.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['power-button.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3('Label'),
    rc.Markdown("Set the label and label position with `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.PowerButton(
    on='True',
    label='Label',
    labelPosition='top'
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Size'),
    rc.Markdown("Adjust the size (diameter in pixels) of the power button with `size`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.PowerButton(
    on='True',
    size=100
)''', style=styles.code_container),
    html.H3('Color'),
    rc.Markdown("Set the color of the power button with `color`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.PowerButton(
    on='True',
    color='#FF5E5E'
)''', style=styles.code_container),
    html.Hr(),
    html.H3("Power Button Properties"),
    rc.ComponentReference('PowerButton', lib=daq)
])

# Precision Input
PrecisionInput = html.Div(children=[
    html.H1('Precision Input Examples and Reference'),
    html.Hr(),
    html.H3('Default Precision Input'),
    rc.Markdown("An example of a default precision input without \
            any extra properties."),
    rc.Markdown(
        examples['precision-input.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['precision-input.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),
    html.Hr(),
    html.H3('Label'),
    rc.Markdown("Set the label and label position with `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.PrecisionInput(
    label='Label',
    labelPosition='top',
    precision=2,
    value=12
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Precision'),
    rc.Markdown("The `precision` property is mandatory for this component. The `precision` property \
    indicates the accuracy of the specified number."),
    rc.ComponentBlock('''import dash_daq as daq

daq.PrecisionInput(
    precision=2,
    value=125
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Max and Min'),
    rc.Markdown("Set the maximum and minimum value of the numeric input with `max` and `min`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.PrecisionInput(
    precision=2,
    value=15,
    max=20,
    min=10
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Size'),
    rc.Markdown("Set the length (in pixels) of the numeric input `size`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.PrecisionInput(
    size=120,
    precision=4,
    value=245
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Disabled'),
    rc.Markdown("Disable the precision input by setting `disabled=True`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.PrecisionInput(
    disabled=True,
    precision=4,
    value=9999
)''', style=styles.code_container),
    html.Hr(),
    html.H3("Precision Input Properties"),
    rc.ComponentReference('PrecisionInput', lib=daq)
])

# Stop Button
StopButton = html.Div(children=[
    html.H1('Stop Button Examples and Reference'),
    html.Hr(),
    html.H3('Default Stop Button'),
    rc.Markdown("An example of a default stop button without \
            any extra properties."),
    rc.Markdown(
        examples['stop-button.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['stop-button.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),
    html.H3('Label'),
    rc.Markdown("Set the label and label position with `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.StopButton(
    label='Label',
    labelPosition='top'
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Size'),
    rc.Markdown("Adjust the size (width in pixels) of the stop button with `size`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.StopButton(
    size=120,
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Button Text'),
    rc.Markdown("Set the text displayed in the button `buttonText`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.StopButton(
    buttonText='text',
)''', style=styles.code_container),
    html.Hr(),
    html.H3('Disabled'),
    rc.Markdown("Disable the button by setting `disabled=True`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.StopButton(
    disabled=True,
)''', style=styles.code_container),
    html.Hr(),
    html.H3("Stop Button Properties"),
    rc.ComponentReference('StopButton', lib=daq)
])

# Slider
Slider = html.Div(children=[
    html.H1('Slider Examples and Reference'),
    html.Hr(),
    html.H3('Default Slider'),
    rc.Markdown("An example of a default slider without \
            any extra properties."),
    rc.Markdown(
        examples['slider.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['slider.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),

    html.H3('Marks'),
    rc.Markdown("Set custom marks on the slider using with `marks`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Slider(
    min=0, max=100, value=30,
    marks={'25': 'mark', '50': '50'}
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Size'),
    rc.Markdown("Change the size of the slider using `size`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Slider(
    size=50
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Handle Label'),
    rc.Markdown("Set the labels for the handle that is dragged with `handleLabel`."),
    rc.ComponentBlock('''import dash_daq as daq

daq.Slider(
    id='my-daq-slider',
    value=17,
    handleLabel='Handle'
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Step'),
    rc.Markdown("Change the value of increments or decrements using `step`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Slider(
    min=0,
    max=100,
    value=50,
    handleLabel={"showCurrentValue": True,"label": "VALUE"},
    step=10
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Vertical orientation'),
    rc.Markdown("Make the slider display vertically by setting `vertical=True`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Slider(
    vertical=True
)''', style=styles.code_container),

    html.Hr(),

    html.H3("Slider Properties"),
    rc.ComponentReference("Slider", lib=daq)

])

# Tank
Tank = html.Div(children=[
    html.H1('Tank Examples and Reference'),
    html.Hr(),
    html.H3('Default Tank'),
    rc.Markdown("An example of a default tank without \
            any extra properties."),
    rc.Markdown(
        examples['tank.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['tank.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),

    html.H3('Current value with units'),
    rc.Markdown("Display the current value, along with optional \
    units with the `units` and `showCurrentValue` properties."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Tank(
    value=6,
    showCurrentValue=True,
    units='gallons',
    style={'margin-left': '50px'}
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Height and width') ,
    rc.Markdown("Control the size of the tank by setting \
    `height` and `width`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Tank(
    height=75,
    width=200,
    value=6,
    style={'margin-left': '50px'}
)
''', style=styles.code_container),

    html.Hr(),

    html.H3('Label'),
    rc.Markdown("Display a label alongside your tank in the \
    specified position with `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Tank(
    value=3,
    label='Tank label',
    labelPosition='bottom'
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Custom scales'),
    rc.Markdown("Control the intervals at which labels are displayed, \
    as well as the labels themselves with the `scale` property."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Tank(
    value=3,
    scale={'interval': 2, 'labelInterval': 2,
           'custom': {'5': 'Set point'}},
    style={'margin-left': '50px'}
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Logarithmic'),
    rc.Markdown("Use a logarithmic scale for the tank with the specified \
    base by setting `logarithmic=True`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Tank(
    min=0,
    max=10,
    value=300,
    logarithmic=True,
    base=3,
    style={'margin-left': '50px'}
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Tank Properties'),
    rc.ComponentReference("Tank", lib=daq)
])

# Thermometer
Thermometer = html.Div(children=[
    html.H1('Thermometer Examples and Reference'),
    html.Hr(),
    html.H3('Default Thermometer'),
    rc.Markdown("An example of a default Thermometer without \
            any extra properties."),
    rc.Markdown(
        examples['thermometer.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['thermometer.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),

    html.H3('Current value with units'),
    rc.Markdown("Display the value of the thermometer along with \
    optional units with ` showCurrentValue` and `units`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Thermometer(
    min=95,
    max=105,
    value=100,
    showCurrentValue=True,
    units="C"
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Height and width'),
    rc.Markdown("Control the size of the thermometer by setting \
    `height` and `width`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Thermometer(
    value=5,
    height=150,
    width=5
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Label'),
    rc.Markdown("Display a label alongside the thermometer in \
    the specified position by setting `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Thermometer(
    value=5,
    label='Current temperature',
    labelPosition='top'
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Custom scales'),
    rc.Markdown("Control the intervals at which labels are displayed, \
    as well as the labels themselves with the `scale` property."),
    rc.ComponentBlock('''import dash_daq as daq
daq.Thermometer(
    value=5,
    scale={'start': 2, 'interval': 3,
    'labelInterval': 2, 'custom': {
        '2': 'ideal temperature',
        '5': 'projected temperature'
    }}
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Thermometer Properties'),
    rc.ComponentReference("Thermometer", lib=daq)

])

# Toggle Switch
ToggleSwitch = html.Div(children=[
    html.H1('Toggle Switch Examples and Reference'),
    html.Hr(),
    html.H3('Default Toggle Switch'),
    rc.Markdown("An example of a default toggle switch without \
            any extra properties."),
    rc.Markdown(
        examples['toggle-switch.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['toggle-switch.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),

    html.H3('Vertical orientation'),
    rc.Markdown("Make the switch display vertically by setting `vertical=True`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.ToggleSwitch(
    vertical=True
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Size'),
    rc.Markdown("Adjust the size of the toggle switch with `size`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.ToggleSwitch(
    size=100
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Label'),
    rc.Markdown("Add a label to the toggle switch and specify \
    its position using `label` and `labelPosition`."),
    rc.ComponentBlock('''import dash_daq as daq
daq.ToggleSwitch(
    label='My toggle switch',
    labelPosition='bottom'
)''', style=styles.code_container),

    html.Hr(),

    html.H3('Toggle Switch Properties'),
    rc.ComponentReference("ToggleSwitch", lib=daq)

])

# Dark Theme Provider
DarkThemeProvider = html.Div(children=[
    html.H1('Dark Theme Provider Examples and Reference'),
    html.Hr(),
    html.H3('Default Dark Theme Provider'),
    rc.Markdown("An example of a default dark theme provider without \
            any extra properties."),
    rc.Markdown(
        examples['dark-theme-provider.py'][0],
        style=styles.code_container
    ),
    html.Div(
        examples['dark-theme-provider.py'][1],
        className='example-container',
        style={'overflow-x': 'initial'}
    ),

    html.Hr(),

    html.H3('Dark Theme Provider Properties'),
    rc.ComponentReference("DarkThemeProvider", lib=daq)
])
