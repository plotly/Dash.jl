library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(

  canvas_101 =utils$LoadExampleCode('dash_docs/chapters/dash_canvas/examples/canvas_101.R'),
  canvas_image =utils$LoadExampleCode('dash_docs/chapters/dash_canvas/examples/canvas_image.R'),
  canvas_color =utils$LoadExampleCode('dash_docs/chapters/dash_canvas/examples/canvas_color.R'),
  canvas_annotations=utils$LoadExampleCode('dash_docs/chapters/dash_canvas/examples/canvas_annotations.R'),
  canvas_copy_annotations=utils$LoadExampleCode('dash_docs/chapters/dash_canvas/examples/canvas_copy_annotations.R')
  #canvas_simple_segmentation =utils$LoadExampleCode('dash_docs/chapters/dash_canvas/examples/canvas_simple_segmentation.R')

)

layout <- htmlDiv(list(
    dccMarkdown("## Introduction to dash-canvas"),
    dccMarkdown(""),
    dccMarkdown("
                ``dash-canvas`` is a module for image annotation and image processing
                using Dash. It provides both the ``DashCanvas`` object for drawing
                and annotations on images, and a set of utility functions to process
                images using the annotations.

                ``dash-canvas`` can be used in various fields in which user
                interaction with images is required, such as quality control in
                industry, identification and segmentation of cells or organs in life
                and medical sciences, quantification of phases in materials and
                geosciences, construction of training sets for machine learning, etc.

                Install ``dash-canvas`` with

                ```remotes::install_github('plotly/dash-canvas')```

                ### DashCanvas: a canvas object for annotations

                Let's get started with a simple canvas object
                "),
    htmlDiv(
      list(
        examples$canvas_101$source_code,
        examples$canvas_101$layout),
      className='code-container'),
    dccMarkdown("
                You can draw inside the object with the freehand tool, and use the tool
                buttons to draw lines, zoom in and out, pan, select objects and move them
                inside the canvas.

                ``DashCanvas`` comes with a set of properties which can be adjusted to
                control the geometry of the canvas, the default tool and its properties.
                You can pass a background image either as a filename (``filename`` property)
                or as a data string (``image_content`` property); more examples below.
                "),
    htmlDiv(
      list(
        examples$canvas_image$source_code,
        examples$canvas_image$layout),
      className='code-container'),
    dccMarkdown("
                The height of the canvas is adjusted automatically by keeping the aspect
                ratio of the background image.

                ### Basic callbacks to modify DashCanvas Properties

                Like any Dash component, the properties of a ``DashCanvas`` can be
                modified by other components, via callbacks. Please be sure to have
                read first through the [Dash tutorial](https://dashr.plotly.com/) to
                know how to write callbacks.

                "),
    htmlDiv(
      list(
        examples$canvas_color$source_code,
        examples$canvas_color$layout),
      className='code-container'),
    dccMarkdown('
    In the example above, a slider ``dccSlider()`` and a color picker
    ``daqColorPicker()`` are used to adjust the width and color of the drawing
    brush. We just created an image coloring tool in a few lines of code! You
    can learn more about available components in the [component
    libraries](https://dashr.plotly.com/) section of the Dash documentation. Also
    note that the set of available buttons has been restricted through the
    ``hide_buttons`` properties, in order to keep the app design simple.

    ### Retrieving the geometry of annotations and using utility functions

    The geometry of annotations can be retrieved by pressing the bottom-right
    button of the ``DashCanvas``. This button is called "Save" by default;
    the name can be customized through the ``goButtonTitle`` property.
    This button updates the ``json_data`` property of ``DashCanvas``, which
    is a JSON string with information about the background image and the
    geometry of annotations.
    '),
    htmlDiv(
      list(
        examples$canvas_annotations$source_code,
        examples$canvas_annotations$layout),
      className='code-container'),

    htmlBr(),
    dccMarkdown("More Examples utilizing geometry of annotations to create images is
      currently work in progress and will be added to the documentation soon..."),

    # dccMarkdown("
    #              You can either write custom functions to parse the JSON string, or
    #              use the utility functions included in the `dash_canvas` package. In
    #              particular, ``parse_json_string()`` returns a binary mask with non-zero
    #              pixels displaying the annotations:
    #             "),
    # htmlDiv(
    #   list(
    #     examples$canvas_copy_annotations$source_code,
    #     examples$canvas_copy_annotations$layout),
    #   className='code-container'),
    # dccMarkdown("
    #             The above example used the ``array_to_data_url`` utility function to
    #             transform a ``2D - matrix`` into an image data string.
    #
    #
    #             "),
    # dccMarkdown("Finally, ``dash-canvas`` provides utility functions to process images
    #             given the binary mask derived from annotations:"),
    # htmlDiv("", className='example-container'),
    # dccMarkdown('
    #             These functions rely on [magick - an R wrapper for ``imagemagick``]() to
    #             process matrices as images. Here we used the [watershed algorithm] from ``magick``.'),
    dccMarkdown('

                ### Updating the background image

                The background image can be updated thanks to the ``image_content``
                property (a `character` vector), for example using the ``contents`` property
                of ``dccUpload()`` (an "open file" dialog). Updating ``image_content``
                triggers the update of the ``json_data`` property containing the annotations.

                ### More examples

                A gallery of examples using ``DashCanvas`` is available at
                [plotly/canvas-portal](https://github.com/plotly/canvas-portal).
                ')
    #Might also need to make a reference for EBImage and/or imager
  ))#

#app$run_server()
