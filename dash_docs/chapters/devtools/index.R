library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  local_css = utils$LoadExampleCode('dash_docs/chapters/external_resources/examples/local-css.R'),
  folderHost = utils$LoadExampleCode('dash_docs/chapters/external_resources/examples/folderHost.R'),
  embeddingImages = utils$LoadExampleCode('dash_docs/chapters/external_resources/examples/embeddingImages.R'),
  addingExternalCSS = utils$LoadExampleCode('dash_docs/chapters/external_resources/examples/addingExternalCSS.R'),
  custom_index_string = utils$LoadExampleCode('dash_docs/chapters/external_resources/examples/custom-index-string.R')
)

layout <- htmlDiv(list(
  htmlH1('Dash Dev Tools'),
  dccMarkdown("
Dash Dev Tools is an initiative to make debugging and developing Dash apps
more pleasant. This initiative was sponsored by an [organization](https://plotly.com/products/consulting-and-oem/?_ga=2.46960551.1080104966.1578062860-1986131108.1567098614) and you can
see our work in [our GitHub project](https://github.com/orgs/plotly/projects/3).
_dev_tools features are activated by default when you run the app with `app$run_server(debug=TRUE)`_

## Hot Reloading

New in Dash for R v0.2.0!

By default, Dash includes 'hot-reloading'. This means that Dash will 
automatically refresh your browser when you make a change in your R code
or CSS.

Hot reloading works by running a 'file watcher' that examines your working
directory to check for changes. When a change is detected, Dash reloads
your application in an efficient way automatically. A few notes:

- Hot reloading is triggered when you save a file.
- Dash examines the files in your working directory.
- CSS files are automatically 'watched' by examining the `assets/` folder.
- If only CSS changed, then Dash will only refresh that CSS file.
- When your R code has changed, Dash will re-run the entire file and then refresh the application in the browser.
- If your application initialization is slow, then you might want to consider how to save certain initialization steps to file. For example, if your app initialization downloads a static file from a remote service, perhaps you could include it locally.
- Hot reloading will not save the application's state. For example, if you've selected some items in a dropdown, then that item will be cleared on hot-reload.
- Hot reloading is configurable through a set of parameters. See the Reference section at the end of this page.
- Hot reloading performance may be sluggish if your application directory is very large in size.

### Serving the dev bundles

Component library bundles are minified by default, if you encounter a front-end error in your code,
the variable names will be mangled. By serving the dev bundles, you will see their full names.

### Dev Tools UI
New in Dash for R 0.1.0 and _dash-renderer_ 0.23.0

The new Dev Tools UI provides a simple interface, which consolidates both frontend and backend
errors into an 'error popup' at the top-right corner. This could reduce your context switch among
_terminal, code editor, browser and browser debug console_ while developping a Dash app.
              
To better understand the interaction of callbacks, we visualize the callback function definitions
into a DAG (Directed Acyclic Graph). A Callback Graph icon is available after clicking the debug
icon at the bottom-right corner.
              
After upgrading to React 16 since dash-renderer _0.22.0_, we also leverage the new [Error Handling](https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html) feature
so that all Dash React Components get free [Component Props](https://reactjs.org/docs/typechecking-with-proptypes.html) check from _dash-renderer_.
              
Note: You can disable the check by setting `dev_tools_props_check=FALSE`. But we strongly recommend
fixing the props errors:
> _As of React 16, errors that were not caught by any error boundary will result in unmounting of the whole React component tree._

### Reference
The full set of dev tools parameters are included in `app$run_server`:

- `debug`, `Logical`, activate all the dev tools.
- `dev_tools_ui`, `Logical`, set to `FALSE` to explicitly disable dev tools UI in debugger mode (default=TRUE)
- `dev_tools_props_check`, `Logical`, set to `FALSE` to explicitly disable component props validation (default=TRUE)
- `dev_tools_hot_reload`, `Logical`, set to `TRUE` to enable hot reload (default=FALSE).
- `dev_tools_hot_reload_interval`, `Numeric`, interval in seconds at which the renderer will request the reload hash and update the browser page if it changed. (default=3).
- `dev_tools_hot_reload_watch_interval`, `Numeric`, delay in seconds between each walk of the assets folder to detect file changes. (default=0.5 seconds)
- `dev_tools_hot_reload_max_retry`, `Integer`, number of times the reloader is allowed to fail before stopping and sending an alert. (default=8)
- `dev_tools_silence_routes_logging`, `Logical`, remove the routes access logging from the console.
- `dev_tools_prune_errors`, `Logical`, simplify tracebacks to just user code, omitting stack frames from Dash and Fiery internals. (default=TRUE)

### Settings with environment variables
All the `dev_tools` variables can be set with environment variables, just replace the `dev_tools_` with `dash_` and convert
to uppercase. This allows you to have different run configs without changing the code.

Linux/macOS:

`export DASH_HOT_RELOAD=false`

Windows:

`set DASH_DEBUG=true`
"),

dccMarkdown("
[Back to the Table of Contents](/)
              ")
))
