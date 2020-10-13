import re
import os
import sys

import dash
import dash_core_components as dcc
import dash_html_components as html
import dash_bio

from dash_docs import styles, tools
from dash_docs import reusable_components as rc

import json



# all component names

def get_component_names(library_name):
    '''Gets the names of all components, Python and React, in a library.

    :param (str) library_name: The name of the library for which to
    obtain component names.

    '''

    exec("import {}".format(library_name))

    library = eval(library_name)
    members = dir(library)

    all_components = [member for member in members if re.search(
        r'^[A-Z][a-zA-Z]+$', member
    ) is not None]

    react = [c.__name__ for c in library._components]
    python = [c for c in all_components if c not in react]

    return {'react': react,
            'python': python}


# code containers

def imageComponentBlock(
        example_string,
        location,
        height=None,
        width=400
):
    '''Generate a container that is visually similar to the
    ComponentBlock for components that require an externally hosted image.

    :param (str) example_string: String containing the code that is
    used in the application from the image.
    :param (str) location: The URL of the image.
    :param (int) height: The height of the image.
    :param (int) width: The width of the image.

    :rtype (dict): A dash_html_components div containing the code
    container and the image.

    '''

    try:
        exec(example_string, {})
    except Exception as e:
        print('\nError running\n{}\n{}'.format(
            example_string,
            ('======================================' +
             '======================================')
        ))
        raise e

    demo_location = re.match('.*pic_(.*)\.png\?raw=true', location)

    if demo_location is not None:
        demo_location = demo_location.group(1)
    else:
        demo_location = ''

    return html.Div([
        rc.Markdown(
            '```python  \n' + example_string + '  \n```',
            style=styles.code_container
        ),
        html.Div(
            className='example-container',
            children=[
                dcc.Markdown(
                    '> Try a live demo at http://dash-gallery.plotly.host/docs-demos-dashbio/{}'.format(demo_location, demo_location)
                ),
                html.Img(
                    style={'border': 'none', 'width': '75%', 'max-width': '500px'},
                    src=location
                )
            ]
        )
    ])


def generate_component_example(
        component_name,
        library_name, library_short,
        description='',
        params=None,
        style=None,
        default_id=True,
        datafile=None,
        library_imports=None,
        setup_code='',
        component_wrap=None,
        image_info=None
):
    '''Generate an example for a component, with hyperlinks to the
    appropriate component-specific pages.

    :param (str) component_name: The name of the component as it is
    defined within the package.
    :param (str) library_name: The full name of the library (e.g.,
    dash_bio).
    :param (str) library_short: The short name of the library, used in an
    import statement (i.e., import library_name as library_short).
    :param (str) description: A short string describing the component.
    :param (dict) params: A dictionary that contains the parameters
    assigned to the component that is to be displayed as a live
    example; the keys correspond to the parameter names.
    :param (dict) style: A dictionary that contains any style
    options. The keys correspond to the style parameter names.
    :param (bool) default_id: Whether or not to assign a default ID to
    the component in the example code.
    :param (string) datafile: The name of the data file, if any, used
    for the component. This file should be present in the folder
    specified by the variable DATA_LOCATION_PREFIX.
    :param (list[list]) library_imports: A list for which each element
    is a list with two elements: the first element should be the full
    name of the library, and the second element should be the short
    name of the library. Contains all of the libraries necessary for
    running the example code (e.g., pandas).
    :param (str) setup_code: Any additional code required before
    rendering the component (e.g., parsing a data file).
    :param (str) component_wrap: A string that will wrap the component
    (e.g., if the component needs to be an argument for a dcc.Graph).
    The location of the component code is represented by an
    underscore (_).
    :param (dict) image_info: The URL and, if applicable, the height
    and width of the image of the component.
    :rtype (list[obj]): A list containing the entire section for the
    component in question, including the code block, component demo,
    description, and hyperlinks to the component-specific page.
    '''

    # location of all sample data
    DATA_LOCATION_PREFIX = '''https://raw.githubusercontent.com/plotly/\
dash-bio-docs-files/master/'''

    if library_imports is None:
        library_imports = []

    # parameters for initial declaration of component
    paramstring = '\n  '

    if default_id is True:
        paramstring += 'id=\'my-{}-{}\', '.format(
            library_short,
            component_name.lower())

    if params is not None:
        for key in params.keys():
            paramstring += '{}={}, '.format(key, params[key])

    # style options
    if style is not None:
        styleString = 'style={\n  '
        for key in style.keys():
            styleString += '  \'{}\': \'{}\', '.format(
                key,
                str(style[key])
            )

        # remove comma and space following the last style option
        styleString = styleString[:-2]

        styleString += '\n  }, '
        paramstring += styleString

    # loading data if necessary
    if datafile is not None:
        library_imports.append(
            ['urllib.request', 'urlreq']
        )
        # only decode for python 3
        decode_string = ''
        if sys.version_info >= (3, 0):
            decode_string = '.decode(\"utf-8\")'

        # add data location
        setup_code = '''\ndata = urlreq.urlopen(\n \"{}\" + \n \"{}\"\n).read(){}\n\n'''.format(
            DATA_LOCATION_PREFIX,
            datafile['name'],
            decode_string
        ) + setup_code

        # declare data in component initialization if necessary
        if 'parameter' in datafile.keys():
            paramstring += '{}=data, '.format(
                datafile['parameter']
            )

    # pretty-print param string (spaces for indentation)
    paramstring = paramstring.replace(', ', ',\n  ')

    # remove the characters following the final parameter
    # (',\n  '), and add unindented newline at end
    if(len(paramstring) > 4):
        paramstring = paramstring[:-4] + '\n'
    # if no params were supplied, remove all newlines
    else:
        paramstring = ''

    # format component string
    component_string = '{}.{}({})'.format(
        library_short,
        component_name,
        paramstring
    )
    # wrap component if necessary
    if component_wrap is not None:
        component_string = component_wrap.replace(
            '_', component_string)

    # add imports
    imports_string = ''
    for library in library_imports:
        if library[0] != library[1]:
            imports_string += 'import {} as {}\n'.format(
                library[0],
                library[1]
            )
        else:
            imports_string += 'import {}\n'.format(
                library[0]
            )

    # change urllib package if necessary (due to Python version)
    imports_string = imports_string.replace('urllib.request',
                                            'six.moves.urllib.request')

    # full code
    example_string = '''import {} as {}
{}
{}
component = {}
'''.format(library_name,
           library_short,
           imports_string,
           setup_code,
           component_string)


    # load the iframe if that is where the app is
    if image_info is not None:
        component_demo = imageComponentBlock(
            example_string,
            **image_info
        )
    else:
        component_demo = rc.ComponentBlock(
            example_string
        )

    # full component section
    return [

        html.Hr(),

        html.H3(dcc.Link(component_name,
                         href=tools.relpath('/{}/{}'.format(
                             library_name.replace('_', '-'),
                             component_name.lower())),
                id=component_name.replace(' ', '-').lower())),

        rc.Markdown(description),

        component_demo,

        html.Br(),

        dcc.Link('More {} Examples and Reference'.format(component_name),
                 href=tools.relpath('/{}/{}'.format(
                     library_name.replace('_', '-'),
                     component_name.lower())))
    ]


# full documentation page for library

def generate_docs(
        library_name,
        library_short,
        library_heading,
        library_install_instructions,
        library_components
):
    '''Generate full documentation for a library.

    :param (str) library_name: The full name of the library (e.g.,
    dash_bio).
    :param (str) library_short: The short name of the library, used in an
    import statement (i.e., import library_name as library_short).
    :param (obj) library_heading: A rc.Markdown object that will be
    at the top of the documentation page; it should provide a brief
    description of the library.
    :param (obj) library_install_instructions: A dcc.SyntaxHighlighter
    object that contains the code needed to install the library.
    :param (dict[dict]) library_components: A dictionary for which the
    keys are the names of the components that are to be displayed, and
    the values are dictionaries that can be used by the function
    generate_component_example.

    :rtype (list[object]): The children of the layout for the
    documentation page.

    '''

    layout_children = library_heading

    layout_children.append(library_install_instructions)

    sorted_keys = list(library_components.keys())
    sorted_keys.sort()

    for component in sorted_keys:
        layout_children += generate_component_example(
            component,
            library_name,
            library_short,
            **library_components[component]
        )

    return layout_children


# individual component pages

def create_default_example(
        component_name,
        example_code,
        styles,
        component_hyphenated
):
    '''Generate a default example for the component-specific page.

    :param (str) component_name: The name of the component as it is
    defined within the package.
    :param (str) example_code: The code for the default example.
    :param (dict) styles: The styles to be applied to the code
    container.

    :rtype (list[object]): The children of the layout for the default
    example.
    '''

    return [
        rc.Markdown('See [{} in action](http://dash-gallery.plotly.host/dash-{}).'.format(
            component_name,
            component_hyphenated
        )),

        html.Hr(),

        html.H3("Default {}".format(
            component_name
        )),
        html.P("An example of a default {} component without \
        any extra properties.".format(
            component_name
        )),
        rc.Markdown(
            example_code[0]
        ),
        html.Div(
            example_code[1],
            className='example-container'
        ),
        html.Hr()
    ]


def create_examples(
        examples_data
):
    examples = []
    for example in examples_data:
        examples += [
            html.H3(example['param_name'].title()),
            rc.Markdown(example['description']),
            rc.ComponentBlock(example['code']),
            html.Hr()
        ]
    return examples


def generate_prop_table(
        component_name,
        component_names,
        library_name
):
    '''Generate a prop table for each component (both React and Python).

    :param (str) component_name: The name of the component as it is
    defined within the package.
    :param (dict[list]) component_names: A dictionary defining which
    components are React components, and which are Python
    components. The keys in the dictionary are 'react' and 'python',
    and the values for each are lists containing the names of the
    components that belong to each category.
    :param (str) library_name: The name of the library.

    :rtype (object): An html.Table containing data on the props of the component.

    '''

    regex = {
         'python': r'^\s*([a-zA-Z_]*)\s*\(([a-zA-Z\/]*);\s*([a-z]*)\):\s*(.*?)\s*(\(Default:\s*(.*)\)|)\s*$'
    }

    component_type = 'react' \
        if component_name in component_names['react'] else 'python'

    tableRows = [html.Tr([
        html.Th('Attribute'),
        html.Th('Description'),
        html.Th('Type'),
        html.Th('Default value')
    ])]

    exec("import {}".format(library_name))

    if component_type == 'python':
        sep = '\n-'
        doc = eval("{}.{}".format(library_name, component_name)).__doc__

        props = doc.split(sep)

    elif component_type == 'react':

        path = os.path.join(os.path.dirname(os.path.abspath(eval(library_name).__file__)),
                            'metadata.json')
        with open(path, 'r') as f:
            metadata = json.load(f)

        # Mol3d for some reason is a plain JS file, not a react file
        cname = '{}.react.js'.format(component_name)
        if component_name == 'Molecule3dViewer':
            cname = 'Molecule3dViewer.js'
        elif component_name == 'Molecule2dViewer':
            cname = 'Molecule2dViewer.react.js'
        docs = metadata['src/lib/components/{}'.format(cname)]

        props = docs['props']

    for prop in props:
        if component_type == 'python':
            desc_sections = prop.split('\n\n')

            partone = desc_sections[0].replace('    ', ' ')

            r = re.match(
                re.compile(regex[component_type]),
                partone.replace('\n', ' ')
            )

            if r is None:
                continue

            (prop_name, prop_type, prop_optional, prop_desc, _, prop_default) = r.groups()
            if prop_default is None:
                prop_default = ''
            if 'optional' in prop_optional:
                prop_optional = ''

            if len(desc_sections) > 1:
                prop_desc += ' '
                prop_desc += desc_sections[1]

        elif component_type == 'react':
            prop_name = prop
            prop_desc = props[prop]['description']
            prop_type = js_to_py_type(props[prop]['type'])

            if 'defaultValue' in props[prop].keys():
                prop_default = props[prop]['defaultValue']['value']
            else:
                prop_default = ''

        tableRows.append(
            html.Tr([html.Td(rc.Markdown(prop_name)),
                     html.Td(rc.Markdown(prop_desc)),
                     html.Td(rc.Markdown(prop_type)),
                     html.Td(rc.Markdown('```python \n' + prop_default + '\n```'))])
        )

    return html.Div([
        html.H3("{} Properties".format(component_name)),
        html.Table(tableRows)
    ])


def create_doc_page(examples, component_names, component_hyphenated, component_examples=None):
    '''Generates a documentation page for a component.

    :param (dict[object]) examples: A dictionary that contains the
    loaded examples for all components.
    :param (dict[list]) component_names: A dictionary defining which
    components are React components, and which are Python
    components. The keys in the dictionary are 'react' and 'python',
    and the values for each are lists containing the names of the
    components that belong to each category.
    :param (string) component_hyphenated: The name of the component in snake
    case, with underscores (_) replaced with dashes (-).

    :rtype (object): A div containing the contents of the component's
    documentation page.
    '''
    component_name = component_hyphenated\
        .replace('-', ' ')\
        .title()\
        .replace(' ', '')\
        .replace('.Py', '')

    if component_examples is None:
        component_examples = []
    component_examples = create_examples(component_examples)

    if component_name == 'Molecule3DViewer':
        component_name = 'Molecule3dViewer'
    elif component_name == 'Molecule2DViewer':
        component_name = 'Molecule2dViewer'

    return html.Div(
        children=[
            html.H1('{} Examples and Reference'.format(
                component_name))] +
        create_default_example(component_name,
                               examples[component_hyphenated],
                               styles,
                               component_hyphenated.replace('.py', '')) +
        component_examples +
        [rc.ComponentReference(
            component_name,
            lib=dash_bio)]
    )
