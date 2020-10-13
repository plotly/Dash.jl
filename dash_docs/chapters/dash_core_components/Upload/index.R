library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)
library(dashTable)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

examples <- list(
  uploadcomp = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Upload/examples/uploadcomp.R'),
  uploadcomp3 = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Upload/examples/uploadcomp3.R'),
  uploadcomp2 = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Upload/examples/uploadcomp2.R'),
  uploadproptable = utils$LoadExampleCode('dash_docs/chapters/dash_core_components/Upload/examples/uploadproptable.R')
)

layout <- htmlDiv(list(
  htmlH1('Upload Component'),
  dccMarkdown("
The Dash upload component allows your app's viewers to upload files,
like excel spreadsheets or images, into your application.
Your Dash app can access the contents of an upload by listening to
the `contents` property of the `dccUpload` component.
`contents` is a base64 encoded string that contains the files contents,
no matter what type of file: text files, images, zip files,
excel spreadsheets, etc."),

Syntax(
children = examples$uploadcomp$source,
summary = dccMarkdown("Here's an example that parses CSV or Excel files and displays
the results in a table. Note that this example uses the
`DataTable` from the [dash-table](https://github.com/plotly/dash-table)
project.")
    ),

  Example(examples$uploadcomp$layout),
  
Syntax(
children = examples$uploadcomp2$source,
summary = dccMarkdown("This next example responds to image uploads by displaying them
in the app with the `htmlImg` component.")
  ),
Example(examples$uploadcomp2$layout),
  
Syntax(
children = examples$uploadcomp3$source,
summary = dccMarkdown("The `children` attribute of the `Upload` component accepts any
Dash component. Clicking on the children element will trigger the
upload action, as will dragging and dropping files.
Here are a few different ways that you could style the upload
component using standard dash components.")
    ),
Example(examples$uploadcomp3$layout),

htmlHr(),

htmlH2('Upload Component Properties'),

examples$uploadproptable$layout

))



