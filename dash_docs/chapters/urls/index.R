library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

layout <- htmlDiv(list(
  htmlH1('Multi-Page Apps and URL Support'),
  dccMarkdown("
Dash renders web applications as a 'single-page app'. This means
that the application does not completely reload when the user
navigates the application, making browsing very fast.

There are two new components that aid page navigation:
[`dccLocation`](dash-core-components/location) and `dccLink`.

`dccLocation` represents the location bar in your web browser
through the pathname property. Here's a simple example:

```r
    library(dash)
    library(dashCoreComponents)
    library(dashHtmlComponents)

    app <- Dash$new(external_stylesheets = list('https://codepen.io/chriddyp/pen/bWLwgP.css'))

    app$layout(htmlDiv(list(
              # represents the URL bar, doesn't render anything
              dccLocation(id = 'url', refresh=FALSE),
              dccLink('Navigate to \"/\"', href='/'),
              htmlBr(),
              dccLink('Navigate to \"/page-2\"', href='/page-2'),

              # content will be rendered in this element
              htmlDiv(id='page-content')
            )
        )
    )
`
    app$callback(output=list(id='page-content', property='children'),
                 params=list(
              input(id='url', property='pathname')),
              function(pathname)
              {
              sprintf('You are on page %s', pathname)
              }
    )

    app$run_server(debug = TRUE)
```

In this example, the callback `display_page` receives the
current `pathname` (the last part of the URL) of the page.
The callback simply displays the pathname on page but it
could use the `pathname` to display different content.

The `dccLink` element updates the pathname of the browser
_without refreshing the page_. If you used a `htmlA` element
instead, the pathname would update but the page would refresh.

Here is a GIF of what this example looks like. Note how
clicking on the `Link` doesn't refresh the page even though
it updates the URL!

---
"),
  htmlImg(
           style = list(height = '100%'),
           src = '/assets/images/gallery/url-support.gif'
  ),
dccMarkdown("

You can modify the example above to display different pages
depending on the URL:

```r
    library(dash)
    library(dashHtmlComponents)
    library(dashCoreComponents)

    # Since we're adding callbacks to elements that don't exist in the app.layout,
    # Dash will raise an exception to warn us that we might be
    # doing something wrong.
    # In this case, we're adding the elements through a callback, so we can ignore
    # the exception.
    app <- Dash$new(suppress_callback_exceptions = TRUE,
                    external_stylesheets = list('https://codepen.io/chriddyp/pen/bWLwgP.css'))

    app$layout(htmlDiv(list(
        dccLocation(id='url', refresh=TRUE),
        htmlDiv(id='page-content')
        )
       )
    )

    index_page <- htmlDiv(list(
        dccLink('Go to Page 1', href='/page-1'),
        htmlBr(),
        dccLink('Go to Page 2', href='/page-2')
        )
     )

    page_1_layout <- htmlDiv(list(
        htmlH1('Page 1'),
        dccDropdown(
            id='page-1-dropdown',
            options = lapply(list('LA', 'NYC', 'MTL'), function(x) {
                list(label = x, value = x)
            }),
            value = 'LA'
        ),
        htmlDiv(id='page-1-content'),
        htmlBr(),
        dccLink('Go to Page 2', href='/page-2'),
        htmlBr(),
        dccLink('Go back to home', href='/')
        )
    )

    app$callback(output=list(id='page-1-content', property='children'),
                 params=list(
                     input(id='page-1-dropdown', property='value')),
                     function(value)
                     {
                         sprintf('You have selected %s', value)
                     }
    )

    page_2_layout <- htmlDiv(list(
        htmlH1('Page 2'),
              dccRadioItems(
              id='page-2-radios',
              options = lapply(list('Orange', 'Blue', 'Red'), function(x) {
              list(label = x, value = x)
              }),
              value = 'Orange'
              ),
              htmlDiv(id='page-2-content'),
              htmlBr(),
              dccLink('Go to Page 1', href='/page-1'),
              htmlBr(),
              dccLink('Go back to home', href='/')
       )
    )

    app$callback(output=list(id='page-2-content', property='children'),
                 params=list(
              input(id='page-2-radios', property='value')),
              function(value)
              {
              sprintf('You have selected %s', value)
              }
    )

    # Update the index
    app$callback(output=list(id='page-content', property='children'),
                 params=list(
              input(id='url', property='pathname')),
              function(pathname)
              {
                  if (pathname == '/page-1')
                      return(page_1_layout)
                  else if (pathname == '/page-2')
                      return(page_2_layout)
                  else
                      return(index_page)
              }
    )

    app$run_server(debug=TRUE)
```
"),
  htmlImg(
           style = list(height = '100%'),
           src = '/assets/images/gallery/url-support-pages.gif'
  ),
dccMarkdown("
- In this example, we're displaying different layouts through
the `display_page` function. A few notes: Each page can have
interactive elements even though those elements may not be in
the initial view. Dash handles these \"dynamically generated\"
components gracefully: as they are rendered, they will trigger
the callbacks with their initial values.
- Since we're adding callbacks to elements that don't exist
in the app.layout, Dash will raise an exception to warn us that
we might be doing something wrong. In this case, we're adding
the elements through a callback, so we can ignore the exception
by setting `app$run_server(suppress_callback_exceptions = TRUE)`. It
is also possible to do this without suppressing callback exceptions.
See the example below for details.
- You can modify this example to import the different page's `layout`s
in different files.
- This Dash Userguide that you're looking at is itself a multi-page
Dash app, using these same principles.

---

## Structuring a Multi-Page App

Here's how to structure a multi-page app, where each app is contained
in a separate file.

File structure:

```
- app.R
- index.R
- apps
|-- app1.R
|-- app2.R
```

---

`app.R`

```r
    library(dash)

    app <- Dash$new(suppress_callback_exceptions = TRUE,
                    external_stylesheets = list('https://codepen.io/chriddyp/pen/bWLwgP.css'))
```

`apps/app1.R`

```r
    library(dash)
    library(dashHtmlComponents)
    library(dashCoreComponents)

    app1_layout <- htmlDiv(list(
        htmlH3('App 1'),
              dccDropdown(
                 id='app-1-dropdown',
                 options = lapply(list('NYC', 'MTL', 'LA'), function(x) {
                               list(label = sprintf('App 1 - %s', x), value = x)
                           })
              ),
              htmlDiv(id='app-1-display-value'),
              dccLink('Go to App 2', href='/apps/app2')
        )
    )

    app$callback(output=list(id='app-1-display-value', property='children'),
                 params=list(
              input(id='app-1-dropdown', property='value')),
              function(value)
              {
              sprintf('You have selected %s', value)
              }
    )


    app$run_server(debug=TRUE)
```
And similarly for other apps

---

`index.R`

`index.R` loads different apps on different URLs like this:

```r
    library(dash)
    library(dashHtmlComponents)
    library(dashCoreComponents)

    app$layout(htmlDiv(list(
        dccLocation(id='url', refresh=FALSE),
        htmlDiv(id='page-content')
        )
       )
    )

    app$callback(output=list(id='page-content', property='children'),
                 params=list(
              input(id='url', property='pathname')),
              function(pathname)
              {
                  if (pathname == '/apps/app1')
                      return(app1_layout)
                  else if (pathname == '/apps/app2')
                      return(app2_layout)
                  else
                      return('404')
              }
    )

    app$run_server(debug=TRUE)
```

---

Alternatively, you may prefer a flat project layout with callbacks and layouts separated into different files:

```
- app.R
- index.R
- callbacks.R
- layouts.R
```

---

`app.R`
```r
    library(dash)

              app <- Dash$new(suppress_callback_exceptions = TRUE,
              external_stylesheets = list('https://codepen.io/chriddyp/pen/bWLwgP.css'))
```

---

`callbacks.R`

```r
    app$callback(output=list(id='app-1-display-value', property='children'),
                 params=list(
              input(id='app-1-dropdown', property='value')),
              function(value)
              {
              sprintf('You have selected %s', value)
              }
    )

    app$callback(output=list(id='app-2-display-value', property='children'),
                 params=list(
              input(id='app-1-dropdown', property='value')),
              function(value)
              {
              sprintf('You have selected %s', value)
              }
    )
```

---

`layouts.R`

```r
    library(dash)
    library(dashHtmlComponents)
    library(dashCoreComponents)

    app1_layout <- htmlDiv(list(
        htmlH3('App 1'),
              dccDropdown(
              id='app-1-dropdown',
              options = lapply(list('NYC', 'MTL', 'LA'), function(x) {
              list(label = sprintf('App 1 - %s', x), value = x)
              })
              ),
              htmlDiv(id='app-1-display-value'),
              dccLink('Go to App 2', href='/apps/app2')
        )
    )

    app2_layout <- htmlDiv(list(
        htmlH3('App 2'),
              dccDropdown(
              id='app-2-dropdown',
              options = lapply(list('NYC', 'MTL', 'LA'), function(x) {
              list(label = sprintf('App 2 - %s', x), value = x)
              })
              ),
              htmlDiv(id='app-2-display-value'),
              dccLink('Go to App 1', href='/apps/app1')
        )
    )
```

---

`index.R`

```r
    library(dash)
    library(dashHtmlComponents)
    library(dashCoreComponents)

    app$layout(htmlDiv(list(
        dccLocation(id='url', refresh=FALSE),
        htmlDiv(id='page-content')
        )
      )
    )

    app$callback(output=list(id='page-content', property='children'),
                 params=list(
              input(id='url', property='pathname')),
              function(pathname)
              {
              if (pathname == '/apps/app1')
                  return(app1_layout)
              else if (pathname == '/apps/app2')
                  return(app2_layout)
              else
                  return('404')
              }
    )

  app$run_server(debug=TRUE)
```

---

It is worth noting that in both of these project structures, the Dash instance is defined in a separate
`app.R`, while the entry point for running the app is `index.R`. This separation is required to avoid circular
imports: the files containing the callback definitions require access to the Dash app instance however if
this were imported from `index.R`, the initial loading of `index.R` would ultimately require itself to be
already imported, which cannot be satisfied.
  "),
htmlHr(),
dccMarkdown("
[Back to the Table of Contents](/)
              ")
))
