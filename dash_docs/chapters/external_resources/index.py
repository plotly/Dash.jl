# -*- coding: utf-8 -*-
import dash_core_components as dcc
import dash_html_components as html

from dash_docs import styles
from dash_docs.tools import load_example, read_file, relpath
from dash_docs import reusable_components as rc

examples = {
    'local-css': load_example(
        'chapters/external_resources/examples/local-css.py',
        relative_path=True
    ),
    'custom-index-string': read_file(
        'chapters/external_resources/examples/custom-index-string.py'
    ),
    'custom-interpolate-string': read_file(
        'chapters/external_resources/examples/custom-interpolate-string.py'
    ),
    'dash-meta-tags': read_file(
        'chapters/external_resources/examples/dash-meta-tags.py'
    ),
    'custom-dash-renderer': read_file(
        'chapters/external_resources/examples/custom-dash-renderer.py'
    ),
    'custom-dash-renderer-hooks': read_file(
        'chapters/external_resources/examples/custom-dash-renderer-hooks.py'
    ),
    'external-resources-init': read_file(
        'chapters/external_resources/examples/external-resources-init.py'
    ),
}


layout = html.Div([
    html.H1('Adding CSS & JS and Overriding the Page-Load Template'),

    rc.Markdown('''
    Dash applications are rendered in the web browser with CSS and JavaScript.
    On page load, Dash serves a small HTML template that includes references to
    the CSS and JavaScript that are required to render the application.
    This chapter covers everything that you need to know about configuring
    this HTML file and about including external CSS and JavaScript in Dash
    applications.

    **Table of Contents**
    - Adding Your Own CSS and JavaScript to Dash Apps
    - Embedding Images in Your Dash Apps
    - Changing the Favicon
    - Adding External CSS and JavaScript
    - Customizing the page title and the "Updating..." title
    - Customizing Dash's HTML Index Template
    - Adding Meta Tags
    - Serving Dash's Component Libraries Locally or from a CDN
    - Sample Dash CSS Stylesheet
    ***

    ## Adding Your Own CSS and JavaScript to Dash Apps

    **New in dash 0.22.0**

    Including custom CSS or JavaScript in your Dash apps is simple.
    Just create a folder named `assets` in the root of your app directory
    and include your CSS and JavaScript
    files in that folder. Dash will automatically serve all of the files that
    are included in this folder. By default the url to request the assets will
    be `/assets` but you can customize this with the `assets_url_path` argument
    to `dash.Dash`.

    **Important: For these examples, you need to include `__name__` in your Dash constructor.**

    That is, `app = dash.Dash(__name__)` instead of `app = dash.Dash()`. [Here's why](https://community.plotly.com/t/dash-app-does-not-load-assets-and-app-index-string/12178/10?u=chriddyp).

    ### Example: Including Local CSS and JavaScript

    We'll create several files: `app.py`, a folder named `assets`, and
    three files in that folder:
    ```bash
    - app.py
    - assets/
        |-- typography.css
        |-- header.css
        |-- custom-script.js
    ```
    &nbsp;

    `app.py`

    '''),

    rc.Markdown(
        examples['local-css'][0],
        style=styles.code_container
    ),

    html.Hr(),

    html.Div(
        rc.Markdown('`typography.css`'),
        style={'paddingTop': 20}
    ),

    rc.Markdown(
        (
        '''
        ```css
        body {
            font-family: sans-serif;
        }
        h1, h2, h3, h4, h5, h6 {
            color: hotpink
        }
        ```
        '''),
        style=styles.code_container
    ),

    html.Hr(),

    html.Div(
        rc.Markdown('`header.css`'),
        style={'paddingTop': 20}
    ),

    rc.Markdown(
        ('''
        ```css
        .app-header {
            height: 60px;
            line-height: 60px;
            border-bottom: thin lightgrey solid;
        }

        .app-header .app-header--title {
            font-size: 22px;
            padding-left: 5px;
        }
        ```
        '''),
        style=styles.code_container
    ),

    html.Hr(),

    html.Div(
        rc.Markdown('`custom-script.js`'),
        style={'paddingTop': 20}
    ),

    rc.Markdown(
        ('''
        ```js
        alert('If you see this alert, then your custom JavaScript script has run!')
        ```
        '''),
        style=styles.code_container
    ),

    html.Hr(),

    rc.Markdown('''
        When you run `app.py`, your app should look something like this:
        (Note that there may be some slight differences in appearance as
        the CSS from this Dash User Guide is applied to all of these embedded
        examples.)
    '''),

    html.Div(
        examples['local-css'][1],
        className='css-example',
        style={
            'border': 'thin lightgrey solid',
            'marginTop': 40,
            'marginBottom': 40,
        }
    ),

    rc.Markdown('''

    There are a few things to keep in mind when including assets automatically:

    1 - The following file types will automatically be included:

    A - CSS files suffixed with `.css`

    B - JavaScript files suffixed with `.js`

    C - A single file named `favicon.ico` (the page tab's icon)

    2 - Dash will include the files in alphanumerical order by filename.
    So, we recommend prefixing your filenames with numbers if you need to ensure
    their order (e.g. `10_typography.css`, `20_header.css`)

    3 - You can ignore certain files in your `assets` folder with a regex filter
    using `app = dash.Dash(assets_ignore='.*ignored.*')`. This will prevent Dash from
    loading files which contain the above pattern.

    4 - If you want to include CSS from a remote URL, then see the next section.

    5 - Your custom CSS will be included _after_ the Dash component CSS

    6 - It is recommended to add `__name__` to the dash init to ensure the resources
    in the assets folder are loaded, eg: `app = dash.Dash(__name__, meta_tags=[...])`.
    When you run your application through some other command line (like the
    flask command or gunicorn/waitress), the `__main__` module will no
    longer be located where `app.py` is. By explicitly setting `__name__`,
    Dash will be able to locate the relative `assets` folder correctly.

    ### Hot Reloading

    By default, Dash includes "hot-reloading". This means that Dash will automatically refresh your browser when you make a change in your Python code _and_ your CSS code.

    Give it a try: Change the color in `typography.css` from `hotpink` to `orange` and see your application update.

    > Don't like hot-reloading? You can turn this off with `app.run_server(dev_tools_hot_reload=False)`.
    > Learn more in <dccLink href="/devtools" children="Dash Dev Tools documentation"/>. Questions? See the [community forum hot reloading discussion](https://community.plotly.com/t/announcing-hot-reload/14177).

    '''),

    rc.Markdown('''
***

## Load Assets from a Folder Hosted on a CDN

If you duplicate the file structure of your local assets folder to a folder hosted
externally to your Dash app, you can use `assets_external_path='http://your-external-assets-folder-url'`
in the Dash constructor to load the files from there instead of locally. Dash will index your local
assets folder to find all of your assets, map their relative path onto `assets_external_path`
and then request the resources from there.
`app.scripts.config.serve_locally = False` must also be set in order for this to work.

**NOTE:** In Dash 0.43.0 and before, `app.scripts.config.serve_locally = False`
was the default, except when dev bundles are served (such as during debugging).
Starting with Dash 1.0.0, `serve_locally` defaults to `True`.

**Example:**
'''),

    rc.Markdown(
    '''
    ```py
    import dash
    import dash_html_components as html

    app = dash.Dash(
        __name__,
        assets_external_path='http://your-external-assets-folder-url/'
    )
    app.scripts.config.serve_locally = False
    ```
    ''',
        style=styles.code_container
    ),


    rc.Markdown('''
    ***

    ## Embedding Images in Your Dash Apps

    In addition to CSS and javascript files, you can include images in
    the `assets` folder. An example of the folder structure:

    ```
    - app.py
    - assets/
        |-- image.png

    ```
    &nbsp;

    In your `app.py` file you can use the relative path to that image:
    '''),

    rc.Markdown(
    '''
    ```py
    import dash
    import dash_html_components as html

    app = dash.Dash(__name__)

    app.layout = html.Div([
        html.Img(src='/assets/image.png')
    ])

    if __name__ == '__main__':
        app.run_server(debug=True)
    ```
    ''',
        style=styles.code_container
    ),

    rc.Markdown(
    '''
    > If placing images inside the `assets` folder isn't an option, then you can
    > also embed images "inline" with base64 encoding:
    ```py
    import base64
    import dash
    import dash_html_components as html

    app = dash.Dash(__name__)

    image_filename = 'my-image.png'

    def b64_image(image_filename):
        with open(image_filename, 'rb') as f:
            image = f.read()
        return 'data:image/png;base64,' + base64.b64encode(image).decode('utf-8')

    app.layout = html.Img(src=b64_image(image_filename))
    ```
    '''
    ),

    rc.Markdown('''
    ***

    ## Changing the Favicon

    It is possible to override the default favicon by adding
    a file named `favicon.ico` to your `/assets` folder. Changes to
    this file will implement cache-busting automatically.

    ```
    - app.py
    - assets/
        |-- favicon.ico

    ```
    '''),


    rc.Markdown('''
    ***

    ## Adding external CSS/Javascript

    You can add resources hosted externally to your Dash app with the
    `external_stylesheets` & `external_scripts` init keywords.

    The resources can be either a string or a dict containing the tag attributes
    (`src`, `integrity`, `crossorigin`, etc). You can mix both.

    External css/js files are loaded before the assets.

    **Example:**
    '''),

    rc.Markdown(
        '```python  \n' + examples['external-resources-init'] + '  \n```',
        style=styles.code_container
    ),

    rc.Markdown('''
    ## Customizing Dash's Document or Browser Tab Title
    The Document Title is the name of the web page that appears in your
    web browser's tab.

    By default, it is Dash.

    As of Dash 1.14.0, you can customize this title with the `title=` keyword:
    ```py
    app = dash.Dash(__name__, title='Weekly Analytics')
    ```

    > Note - Prior to 1.14.0, setting `app.title` was an unnofficial way to
    > set this title. This is still possible but may be removed in the future.
    > We recommend using `title=` instead.

    ## Update the Document Title Dynamically based off of the URL or Tab

    To set the document title dynamically, you can use a clientside callback
    that updates the `document.title` as a side effect. The example below
    sets the `document.title` based off of the currently selected tab.

    ```python
    import dash
    from dash.dependencies import Input, Output
    import dash_html_components as html
    import dash_core_components as dcc

    app = dash.Dash(__name__)

    app.layout = html.Div([
        html.Div(id='blank-output'),
        dcc.Tabs(id='tabs-example', value='tab-1', children=[
            dcc.Tab(label='Tab one', value='tab-1'),
            dcc.Tab(label='Tab two', value='tab-2'),
        ]),
    ])


    app.clientside_callback(
        """
        function(tab_value) {
            if (tab_value === 'tab-1') {
                document.title = 'Tab 1'
            } else if (tab_value === 'tab-2') {
                document.title = 'Tab 2'
            }
        }
        """,
        Output('blank-output', 'children'),
        [Input('tabs-example', 'value')]
    )

    if __name__ == '__main__':
        app.run_server(debug=True)
    ```

    Updating the page based off of the URL would be similar: the input of the
    callback would be the `pathname` property of `dcc.Location`. See the
    <dccLink href="/urls" children="URLs and Multi Page Apps"/> chapter for
    a `dcc.Location` example.

    ## Customizing or Removing Dash's "Updating..." Message

    When a callback is running, Dash updates the document title
    (the title that appears in your browser tab) with the "Updating..."
    message.

    Customize this message with the `update_title=` property:

    ```python
    app = dash.Dash(__name__, update_title='Loading...')
    ```

    Or, prevent this message from appearing at all by setting `update_title=None`:
    ```python
    app = dash.Dash(__name__, update_title=None)
    ```


    ***

    ## Customizing Dash's HTML Index Template

    Dash's UI is generated dynamically with Dash's React.js front-end. So,
    on page load, Dash serves a very small HTML template string that includes
    the CSS and JavaScript that is necessary to render the page and some simple
    HTML meta tags.

    This simple HTML string is customizable. You might want to customize this
    string if you wanted to:
    - Customize the way that your CSS or JavaScript is included in the page.
    For example, if you wanted to include remote scripts or if you wanted to
    include the CSS _before_ the Dash component CSS
    - Include custom meta tags in your app. Note that meta tags can also be
    added with the `meta_tags` argument (example below).
    - Include a custom version of `dash-renderer`, by instantiating the
    `DashRenderer` class yourself. You can add request hooks this way, by providing
    a `hooks` config object as in the example below.


    #### Usage

    **Option 1 - `index_string`**

    Add an `index_string` to modify the default HTML Index Template:

    '''),

    rc.Markdown(
        '```python  \n' + examples['custom-index-string'] + '  \n```',
        style=styles.code_container
    ),

    rc.Markdown('''

    The `{%key%}`s are template variables that Dash will fill in automatically
    with default properties. The available keys are:

    `{%metas%}` (optional)

    The registered meta tags included by the `meta_tags` argument in `dash.Dash`

    `{%favicon%}` (optional)

    A favicon link tag if found in the `assets` folder.

    `{%css%}` (optional)

    `<link/>` tags to css resources. These resources include the Dash component
    library CSS resources as well as any CSS resources found in the `assets` folder.

    `{%title%}` (optional)

    The contents of the page `<title>` tag.
    [Learn more about `<title/>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/title)

    `{%config%}` (required)

    An auto-generated tag that includes configuration settings passed from
    Dash's backend to Dash's front-end (`dash-renderer`).

    `{%app_entry%}` (required)

    The container in which the Dash layout is rendered.

    `{%scripts%}` (required)

    The set of JavaScript scripts required to render the Dash app.
    This includes the Dash component JavaScript files as well as any
    JavaScript files found in the `assets` folder.

    `{%renderer%}` (required)

    The JavaScript script that instantiates `dash-renderer` by calling
    `new DashRenderer()`

    **Option 2 - `interpolate_index`**

    If your HTML content isn't static or if you would like to introspect or modify
    the templated variables, then you can override the `Dash.interpolate_index`
    method.
    '''),

    rc.Markdown(
        '```python  \n' + examples['custom-interpolate-string'] + '  \n```',
        style=styles.code_container
    ),

    rc.Markdown('''
    Unlike the `index_string` method, where we worked with template string
    variables, the keyword variables that are passed into `interpolate_index`
    are already evaluated.
    '''),

    rc.Markdown('''

    In the example above, when we print the input arguments of
    `interpolate_index` we should see an output like this:
    '''),

    html.Div(rc.Markdown("""
```
{
    'title': 'Dash',
    'app_entry': '\\n<div id="react-entry-point">\\n    <div class="_dash-loading">\\n        Loading...\\n    </div>\\n</div>\\n',
    'favicon': '',
    'metas': '<meta charset="UTF-8"/>',
    'scripts': '<script src="https://unpkg.com/react@15.4.2/dist/react.min.js"></script>\\n<script src="https://unpkg.com/react-dom@15.4.2/dist/react-dom.min.js"></script>\\n<script src="https://unpkg.com/dash-html-components@0.14.0/dash_html_components/bundle.js"></script>\\n<script src="https://unpkg.com/dash-renderer@0.20.0/dash_renderer/bundle.js"></script>',
    'renderer': '<script id="_dash-renderer" type="application/javascript">var renderer = new DashRenderer();</script>',
    'config': '<script id="_dash-config" type="application/json">{"requests_pathname_prefix": "/", "url_base_pathname": "/"}</script>',
    'css': ''
}
```"""), style={'overflowX': 'scroll'}),
    rc.Markdown('''
    The values of the `scripts` and `css` keys may be different depending on
    which component libraries you have included or which files
    might be in your assets folder.

    ***

    ## Customizing dash-renderer with request hooks

    To instantiate your own version of `dash-renderer`, you can override Dash's HTML Index Template and provide your own script that will be used instead of the standard script. This script should
    somewhere call `var renderer = new DashRenderer();`, which instantiates the `DashRenderer` class. You can add this script to your index HTML when you're setting
    `app.index_string`, or you could simply override `app.renderer` like so:

    '''),

    rc.Markdown(
        '```python  \n' + examples['custom-dash-renderer'] + '  \n```',
        style=styles.code_container
    ),

    rc.Markdown('''

    When you provide your own DashRenderer, you can also pass in a `hooks` object that holds `request_pre` and `request_post` functions. These request hooks will be fired
    before and after Dash makes a request to its backend. Here's an example:

    '''),

    rc.Markdown(
        '```python  \n' + examples['custom-dash-renderer-hooks'] + '  \n```',
        style=styles.code_container
    ),

    rc.Markdown('''
    Notice the `request_pre` function takes the payload of the request being sent as its argument, and the `request_post` function takes both the payload and the response of the server
    as arguments. These can be altered in our function, allowing you to modify the response and request objects that Dash sends to the server. In the example above, the `request_pre`
    function is fired before each server call, and in the case of this example, it will `console.log()` the request parameter. The `request_post` function will fire __after__ each server
    call, and in our example will also print out the response parameter.

    ***

    ## Customizing Meta Tags

    > Not sure what meta tags are?
    > [Check out this tutorial on meta tags and why you might want to use them](https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/The_head_metadata_in_HTML).

    To add custom meta tags to your application, you can always override Dash's
    HTML Index Template. Alternatively, Dash provides a shortcut:
    you can specify meta tags directly in the Dash constructor:
    '''),

    rc.Markdown(
        '```python  \n' + examples['dash-meta-tags'] + '  \n```',
        style=styles.code_container
    ),

    rc.Markdown('''

    If you inspect the source of your app, you should see the meta tags appear:

    '''),

    html.Img(
        alt='Dash App with Custom Meta Tags',
        src=relpath('assets/images/gallery/external-resources-head.png')
    ),

    rc.Markdown('''

    ***

    ## Serving Dash's Component Libraries Locally or from a CDN

    **Changed in Dash 1.0.0 - now `serve_locally` defaults to `True`,
    previously it defaulted to `False`**

    Dash's component libraries, like `dash_core_components` and `dash_html_components`,
    are bundled with JavaScript and CSS files. Dash automatically checks with
    component libraries are being used in your application and will automatically
    serve these files in order to render the application.

    By default, dash serves the JavaScript and CSS resources from the
    local files on the server where Dash is running. This is the more flexible
    and robust option: in some cases, such as firewalled or airgapped
    environments, it is the only option. It also avoids some hard-to-debug
    problems like packages that have not been published to NPM or CDN downtime,
    and the unlikely but possible scenario of the CDN being hacked. And of
    course, component developers will want the local version while changing the
    code, so when dev bundles are requested (such as with `debug=True`) we
    always serve locally.

    However, for performance-critical apps served beyond an intranet, online
    CDNs can often deliver these files much faster than loading the resources
    from the file system, and will reduce the load on the Dash server.

    '''),

    rc.Markdown('''
    ```python
    from dash import Dash

    app = dash.Dash(__name__, serve_locally=False)

    ''',
        style={'borderLeft': 'thin lightgrey solid'}
    ),

    rc.Markdown('''

    This will load the bundles from the https://unpkg.com/ cdn which is a community-maintained project that serves JavaScript bundles from NPM. We don't maintain it, so we cannot attest or guarantee to its uptime, performance, security, or long term availability.

    Also note that we don't publish the dev bundles to `unpkg`, so when running the app locally with `python app.py`, the local JS files will be served. When the app is deployed with `gunicorn`, it'll switch to the CDN.

    ***

    ## Sample Dash CSS Stylesheet

    Currently, Dash does not include styles by default.

    To get started with Dash styles, we recommend starting with this [CSS stylesheet](https://codepen.io/chriddyp/pen/bWLwgP?editors=1100) hosted
    on [Codepen](https://codepen.io).

    To include this stylesheet in your application, copy and paste it into a file
    in your `assets` folder. You can view the raw CSS source here:
    [https://codepen.io/chriddyp/pen/bWLwgP.css](https://codepen.io/chriddyp/pen/bWLwgP.css).

    Here is an embedded version of this stylesheet.
    '''),

    html.Iframe(
        src="//codepen.io/chriddyp/embed/bWLwgP/?height=265&"
            "theme-id=light&default-tab=css,result&embed-version=2",
        style={'height': 400, 'width': '100%', 'border': 'none'}
    ),

    rc.Markdown(id='md-syntax-highlight', children='''

    ***

    # Syntax Highlighting With Markdown

    Both [`dash-table`](https://dash.plotly.com/datatable) and
    [`dash-core-components`](https://dash.plotly.com/dash-core-components)
    support markdown formatting; this includes syntax highlighting for
    inline code.

    Highlighting is taken care of by
    [`highlight.js`](https://highlightjs.org/). By default, only
    certain languages are recognized, and there is only one color
    scheme available. However, you can override this by downloading a
    custom `highlight.js` package. To do this, visit
    [https://highlightjs.org/download/](https://highlightjs.org/download/),
    and in the "Custom package" section, check off all of the
    languages that you require, download your package, and place the
    resultant `highlight.pack.js` file into the `assets/` folder for
    your app. The package should also come with a `styles/` directory;
    to use a different color scheme, simply copy the corresponding
    stylesheet into your app's `assets/` folder.
    ''')

])
