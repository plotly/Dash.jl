library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)
source('dash_docs/styles.R')
source('dash_docs/components.R')

examples <- list(
   scoping_wrong = utils$LoadExampleCode('dash_docs/chapters/sharing_data/examples/scoping_wrong.R'),
   scoping = utils$LoadExampleCode('dash_docs/chapters/sharing_data/examples/scoping.R')
#   ex1 = utils$LoadExampleCode('dash_docs/chapters/sharing_data/examples/Example1.R'),
#   ex2 = utils$LoadExampleCode('dash_docs/chapters/sharing_data/examples/Example2.R'),
#   ex3 = utils$LoadExampleCode('dash_docs/chapters/sharing_data/examples/Example3.R'),
#   ex4 = utils$LoadExampleCode('dash_docs/chapters/sharing_data/examples/Example4.R')
)

layout <- htmlDiv(
  list(
    dccMarkdown("
# Sharing State Between Callbacks
> This is the 5th chapter of the essential [Dash Tutorial](https://dashr-docs.herokuapp.com/). The [previous chapter](/graph-crossfiltering)
> covered how to use callbacks with the `dashCoreComponents.Graph` component.
> The rest of the Dash documentation covers other topics like multi-page apps and component libraries.
> Just getting started? Make sure to [install the necessary dependencies](https://dashr-docs.herokuapp.com/installation).
> The [next and final chapter](https://dashr-docs.herokuapp.com/faq-gotchas) covers frequently asked questions and gotchas.

One of the core Dash principles explained in the
[Getting Started Guide on Callbacks](/getting-started-part-2)
is that **Dash Callbacks must never modify variables outside of their
scope**. It is not safe to modify any `global` variables.
This chapter explains why and provides some alternative patterns for
sharing state between callbacks.

## Why Share State?

In some apps, you may have multiple callbacks that depend on expensive data
processing tasks like making SQL queries,
running simulations, or downloading data.

Rather than have each callback run the same expensive task,
you can have one callback run the task and then share the
results to the rest of the callbacks.

This need has been somewhat ameliorated now that you can have
[multiple outputs](/getting-started-part-2) for one callback. This way,
that expensive task can be done once and immediately used in all the
outputs. But in some cases this still isn't ideal, for example if there are
simple follow-on tasks that modify the results, like unit conversions. We
shouldn't need to repeat a large database query just to change the results
from Fahrenheit to Celsius!
    "),
    dccMarkdown("
## Why `global` variables will break your app

Dash is designed to work in multi-user environments
where multiple people may view the application at the
same time and will have **independent sessions**.

If your app uses modified `global` variables,
then one user's session could set the variable to one value
which would affect the next user's session.

Dash is also designed to be able to run with **multiple
workers** so that callbacks can be executed in parallel.

When Dash apps run across multiple workers, their memory
_is not shared_. This means that if you modify a global
variable in one callback, that modification will not be
applied to the rest of the workers.

***

    "),
    dccMarkdown("
Here is a sketch of an app with a callback that modifies data out of it's scope. 
This type of pattern *will not work reliably* for the reasons outlined above.
              "),
    
    examples$scoping_wrong$source_code,
    
    dccMarkdown("
To fix this example, simply re-assign the filter to a new variable inside the callback, 
or follow one of the strategies outlined in the next part of this guide.
              "),
    
    examples$scoping$source_code,
    
    dccMarkdown("
## Sharing Data Between Callbacks

In order to share data safely across multiple R processes, we need to store the data somewhere that is accessible to each of the processes.

There are two main places to store this data:

1 - In the user's browser session

2 - On the disk (e.g. on a file or on a new database)

The following examples illustrate these approaches.

## Example 1 - Storing Data in the Browser with a Hidden Div

To save data in user's browser's session:

- Implemented by saving the data as part of Dash's front-end store through methods explained in 
https://community.plotly.com/t/sharing-a-dataframe-between-plots/6173
- Data has to be converted to a string like JSON for storage and transport
- Data that is cached in this way will *only be available in the user's current session*.
   - If you open up a new browser, the app's callbacks will always compute the data. 
The data is only cached and transported between callbacks within the session.
   - As such, unlike with caching, this method doesn't increase the memory footprint of the app.
   - There could be a cost in network transport. If you're sharing 10MB of data between callbacks, 
then that data will be transported over the network between each callback.
   - If the network cost is too high, then compute the aggregations upfront and transport those. Your app likely won't be displaying 10MB of data, 
it will just be displaying a subset or an aggregation of it.

This example outlines how you can perform an expensive data processing step in one callback, 
serialize the output at JSON, and provide it as an input to the other callbacks. 
This example uses standard Dash callbacks and stores the JSON-ified data inside a hidden div in the app.

```
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new()

global_df <- read.csv('...')

app$layout(
  htmlDiv(
    list(
      dccGraph(id='graph'),
      htmlTable(id='table'),
      dccDropdown(id='dropdown'),

      # Hidden div inside the app that stores the intermediate value
      htmlDiv(id='intermediate-value',
              style=list(display = 'none'))
    )
  )
)

app$callback(
  output(id = 'intermediate-value', property = 'children'),
  list(input(id = 'dropdown', property = 'value')),
  function(value) {

    # some expensive clean data step
    cleaned_df <- your_expensive_clean_or_compute_step(value)

    # more generally, this line would be
    # convert 'data.frame' data structure to 'json' in R
    jsonlite::toJSON(cleaned_df, ...)
  }
)

app$callback(
  output(id = 'graph', property = 'figure'),
  list(input(id = 'intermediate-value', 'children')),
  function(value) {

    # load 'json' in R
    dff <- jsonlite::fromJSON(jsonified_cleaned_data, ...)
    # create your figure with json data
    figure <- create_figure(dff)
    figure
  }
)

app$callback(
  output(id = 'table', property = 'figure'),
  list(input(id = 'intermediate-value', 'children')),
  function(value) {

    # load json in R
    dff <- jsonlite::fromJSON(jsonified_cleaned_data)
    # create your table with json data
    table <- create_table(dff)
    table
  }
)
```
              "),
    dccMarkdown("
## Example 2 - Computing Aggregations Upfront

Sending the computed data over the network can be expensive if the data is large. 
In some cases, serializing this data and JSON can also be expensive.

In many cases, your app will only display a subset or an aggregation of the computed or filtered data. 
In these cases, you could precompute your aggregations in your data processing callback and 
transport these aggregations to the remaining callbacks.

Here's a simple example of how you might transport filtered or aggregated data to multiple callbacks.

```
app$callback(
  output(id = 'intermediate-value', property = 'children'),
  list(input(id = 'dropdown', property = 'value')),
  function(value) {

    cleaned_df <- your_expensive_clean_or_compute_step(value)

    # a few filter steps that compute the data
    # as it's needed in the future callbacks
    df_1 <- cleaned_df[cleaned_df['fruit'] == 'apples', ]
    df_2 <- cleaned_df[cleaned_df['fruit'] == 'oranges', ]
    df_3 <- cleaned_df[cleaned_df['fruit'] == 'figs', ]

    datasets <- list(
      df_1 = jsonlite::toJSON(df_1, ...),
      df_2 = jsonlite::toJSON(df_2, ...),
      df_3 = jsonlite::toJSON(df_3, ...)
    )

    jsonlite::toJSON(datasets, ...)
  })

app$callback(
  output(id = 'graph', property = 'figure'),
  list(input(id = 'intermediate-value', property = 'children')),
  function(jsonified_cleaned_data) {

    datasets <- jsonlite::fromJSON(jsonified_cleaned_data, ...)
    dff <- jsonlite::fromJSON(datasets[['df_1']], ...)
    figure <- create_figure_1(dff)
    figure
  })

app$callback(
  output(id = 'graph', property = 'figure'),
  list(input(id = 'intermediate-value', property = 'children')),
  function(jsonified_cleaned_data) {

    datasets <- jsonlite::fromJSON(jsonified_cleaned_data, ...)
    dff <- jsonlite::fromJSON(datasets[['df_2']], ...)
    figure <- create_figure_2(dff)
    figure
  })

app$callback(
  output(id = 'graph', property = 'figure'),
  list(input(id = 'intermediate-value', property = 'children')),
  function(jsonified_cleaned_data) {

    datasets <- jsonlite::fromJSON(jsonified_cleaned_data, ...)
    dff <- jsonlite::fromJSON(datasets[['df_3']], ...)
    figure <- create_figure_3(dff)
    figure
  })
```
                
    "),

htmlHr(),
dccMarkdown("
[Back to the Table of Contents](/)
              ")
  )
)


# ,
# dccMarkdown("
#             ## Example 3 - Computing Aggregations Upfront
#             
#             This example:
#             
#             - Uses Redis via Flask-Cache for storing 'global variables'. 
#             This data is accessed through a function, the output of which is cached and keyed by 
#             its input arguments.
#             
#             - Uses the hidden div solution to send a signal to the other callbacks when the expensive 
#             computation is complete.
#             
#             - Note that instead of Redis, you could also save this to the file system. 
#             See https://flask-caching.readthedocs.io/en/latest/ for more details.
#             
#             - This 'signaling' is cool because it allows the expensive computation to only take up one process.
#             Without this type of signaling, each callback could end up computing the expensive 
#             computation in parallel, locking four processes instead of one.  
#             
#             This approach is also advantageous in that future sessions can use the pre-computed value. 
#             This will work well for apps that have a small number of inputs.
#             
#             Here's what this example looks like. Some things to note:
#             
#             - I've simulated an expensive process by using a time.sleep(5).
#             
#             - When the app loads, it takes five seconds to render all four graphs.
#             
#             - The initial computation only blocks one process.
#             
#             - Once the computation is complete, the signal is sent and four callbacks are executed in parallel to render the graphs. Each of these callbacks retrieves the data from the 'global store': the Redis or filesystem cache.
#             
#             - I've set processes=6 in app.run_server so that multiple callbacks can be executed in parallel. In production, this is done with something like $ gunicorn --workers 6 --threads 2 app:server
#             
#             - Selecting a value in the dropdown will take less than five seconds if it has already been selected in the past. This is because the value is being pulled from the cache.
#             
#             - Similarly, reloading the page or opening the app in a new window is also fast because the initial state and the initial expensive computation has already been computed.
#             
#             Here's what this example looks like in code:
#             
#             
#             "),
# examples$ex3$source,
# # examples$ex3$layout,
# dccMarkdown("
#             ## Example 4 - User-Based Session Data on the Server
#             
#             The previous example cached computations on the filesystem and those computations were accessible for all users.
#             
#             In some cases, you want to keep the data isolated to user sessions: 
#             one user's derived data shouldn't update the next user's derived data. 
#             One way to do this is to save the data in a hidden Div, as demonstrated in the first example.
#             
#             Another way to do this is to save the data on the filesystem cache with a session ID and 
#             then reference the data using that session ID. Because data is saved on the server instead of 
#             transported over the network, this method is generally faster than the 'hidden div' method.
#             
#             This example was originally discussed in a [Dash Community Forum thread](https://community.plotly.com/t/capture-window-tab-closing-event/7375/2?u=chriddyp&_ga=2.196163180.1151030971.1558964279-1541667138.1549398001).
#             
#             This example:
#             
#             - Caches data using the flask_caching filesystem cache. 
#             You can also save to an in-memory database like Redis.
#             
#             - Serializes the data as JSON. If you are using Pandas, consider serializing with Apache Arrow. [Community thread](https://community.plotly.com/t/fast-way-to-share-data-between-callbacks/8024/2?_ga=2.196163180.1151030971.1558964279-1541667138.1549398001)
#             
#             - Saves session data up to the number of expected concurrent users. This prevents the cache from being overfilled with data.
#             
#             - Creates unique session IDs by embedding a hidden random string into the app's layout and serving a unique layout on every page load.
#             
#             > Note: As with all examples that send data to the client, be aware that these 
#             > sessions aren't necessarily secure or encrypted. These session IDs may be 
#             > vulnerable to [Session Fixation](https://en.wikipedia.org/wiki/Session_fixation) style attacks.
#             
#             Here's what this example looks like in code:
#             "),
# examples$ex4$source,
# # examples$ex4$layout,
# dccMarkdown("
#             There are three things to notice in this example:
#             
#             - The timestamps of the dataframe don't update when we retrieve the data. This data is cached as part of the user's session.
#             
#             - Retrieving the data initially takes five seconds but successive queries are instant, as the data has been cached.
#             
#             - The second session displays different data than the first session: the data that is shared between callbacks is isolated to individual user sessions.
#             
#             Questions? Discuss these examples on the [Dash Community Forum](https://community.plotly.com/c/dash?_ga=2.220271960.1151030971.1558964279-1541667138.1549398001).
#             ")
