import dash_html_components as html
import dash_core_components as dcc
from dash_docs import styles
from dash_docs import tools
import dash_canvas
from dash_docs import reusable_components as rc

examples = tools.load_examples(__file__)

layout = html.Div([
    rc.Markdown('''\
    ## Introduction to dash-canvas

    '''),

    rc.Markdown(
        '''
        ```shell
        pip install dash-canvas=={}
        ```
        '''.format(dash_canvas.__version__),
        style=styles.code_container
    ),

    rc.Markdown('''
    ``dash-canvas`` is a module for image annotation and image processing
    using Dash. It provides both the ``DashCanvas`` object for drawing
    and annotations on images, and a set of utility functions to process
    images using the annotations.

    ``dash-canvas`` can be used in various fields in which user
    interaction with images is required, such as quality control in
    industry, identification and segmentation of cells or organs in life
    and medical sciences, quantification of phases in materials and
    geosciences, construction of training sets for machine learning, etc.

    Install dash-canvas with

    ```pip install -U dash-canvas```

    The source is on GitHub at [plotly/dash-canvas](https://github.com/plotly/dash-canvas).

    ### DashCanvas: a canvas object for annotations

    Let's get started with a simple canvas object.
    '''),

    rc.Markdown(
          examples['canvas_101.py'][0],
          style=styles.code_container
    ),
    html.Div(examples['canvas_101.py'][1], className='example-container'),

    rc.Markdown('''
    You can draw inside the object with the freehand tool, and use the tool
    buttons to draw lines, zoom in and out, pan, select objects and move them
    inside the canvas.

    ``DashCanvas`` comes with a set of properties which can be adjusted to
    control the geometry of the canvas, the default tool and its properties.
    You can pass a background image either as a filename (``filename``
    property) or as a data string (``image_content`` property); more examples
    below).
    '''),

    rc.Markdown(
          examples['canvas_image.py'][0],
          style=styles.code_container
    ),
    html.Div(examples['canvas_image.py'][1], className='example-container'),

    rc.Markdown('''
    The height of the canvas is adjusted automatically by keeping the aspect
    ratio of the background image.

    ### Basic callbacks to modify DashCanvas properties

    Like any Dash component, the properties of a ``DashCanvas`` can be
    modified by other components, via callbacks. Please be sure to have
    read first through the <dccLink children="Dash tutorial" href="/"/> to
    know how to write callbacks.

    '''),

    rc.Markdown(
          examples['canvas_color.py'][0],
          style=styles.code_container
    ),
    html.Div(examples['canvas_color.py'][1], className='example-container'),

    rc.Markdown('''
    In the example above, a slider ``dcc.Slider`` and a color picker
    ``daq.ColorPicker`` are used to adjust the width and color of the drawing
    brush. We just created an image coloring tool in a few lines of code! You
    can learn more about available components in the
    <dccLink children="component libraries" href="/"/> section of the
    Dash documentation. Also
    note that the set of available buttons has been restricted through the
    ``hide_buttons`` properties, in order to keep the app design simple.

    ### Retrieving the geometry of annotations and using utility functions

    The geometry of annotations can be retrieved by pressing the bottom-right
    button of the ``DashCanvas``. This button is called "Save" by default;
    the name can be customized through the ``goButtonTitle`` property.
    This button updates the ``json_data`` property of ``DashCanvas``, which
    is a JSON string with information about the background image and the
    geometry of annotations.
    '''),

    rc.Markdown(
          examples['canvas_annotations.py'][0],
          style=styles.code_container
    ),
    html.Div(examples['canvas_annotations.py'][1], className='example-container'),

    rc.Markdown('''
    You can either write custom functions to parse the JSON string, or
    use the utility functions included in the `dash_canvas` package. In
    particular, ``dash_canvas.utils.parse_json_string`` returns a binary
    mask with non-zero pixels displaying the annotations:
    '''),

    rc.Markdown(
          examples['canvas_copy_annotations.py'][0],
          style=styles.code_container
    ),
    html.Div(examples['canvas_copy_annotations.py'][1], className='example-container'),

    rc.Markdown('''
    The above example uses the ``array_to_data_url`` utility function to
    transform a ``NumPy`` array into an image data string.

    Finally, ``dash-canvas`` provides utility functions to process images
    given the binary mask derived from annotations:
    '''),



    rc.Markdown(
          examples['canvas_simple_segmentation.py'][0],
          style=styles.code_container
    ),
    html.Div(examples['canvas_simple_segmentation.py'][1], className='example-container'),

    rc.Markdown('''
    These functions rely on [scikit-image](http://scikit-image.org) to
    process arrays as images. Here we used the [watershed algorithm](http://scikit-image.org/docs/stable/auto_examples/segmentation/plot_watershed.html)
    from scikit-image.

    ### Updating the background image

    The background image can be updated thanks to the ``image_content``
    property (a ``str``), for example using the ``contents`` property of
    ``dcc.Upload`` (an "open file" dialog). Updating ``image_content``
    triggers the update of the ``json_data`` property containing the
    annotations.

    ### More examples

    A gallery of examples using ``DashCanvas`` is available at
    [plotly/canvas-portal](https://github.com/plotly/canvas-portal).
    '''),

])
