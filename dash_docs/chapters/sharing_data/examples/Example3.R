library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

external_stylesheets <- list(
  # Dash CSS
  'https://codepen.io/chriddyp/pen/bWLwgP.css',
  # Loading screen CSS
  'https://codepen.io/chriddyp/pen/brPBPO.css')

app <- Dash$new(external_stylesheets = external_stylesheets)

# TODO
# CACHE_CONFIG = {
#   # try 'filesystem' if you don't want to setup redis
#   'CACHE_TYPE': 'redis',
#   'CACHE_REDIS_URL': os.environ.get('REDIS_URL', 'localhost:6379')
# }
# cache = Cache()
# cache.init_app(app.server, config=CACHE_CONFIG)

N <- 100

df <- data.frame(
  category = c(rep("apples", 5 * N), 
               rep("oranges", 10 * N), 
               rep("figs", 20 * N), 
               rep("pineapples", 15 * N)),
  stringsAsFactors = FALSE
)

# 5N + 10N + 20N + 15N = 50N
df$x <- rnorm(50 * N)
df$y <- rnorm(50 * N)

app$layout(
  htmlDiv(
    list(
      dccDropdown(
        id = 'dropdown',
        options = list(
          list(label = "apples", value = "apples"),
          list(label = "oranges", value = "oranges"),
          list(label = "figs", value = "figs"),
          list(label = "pineapples", value = "pineapples")
        ),
        value = 'apples'
      ),
      htmlDiv(
        list(
          htmlDiv(list(dccGraph(id = 'graph-1')), className="six columns"),
          htmlDiv(list(dccGraph(id = 'graph-2')), className="six columns")
        ), className="row"),
      htmlDiv(
        list(
          htmlDiv(list(dccGraph(id = 'graph-3')), className="six columns"),
          htmlDiv(list(dccGraph(id = 'graph-4')), className="six columns")
        ), className="row"),
      htmlDiv(id = 'signal', style = list(display = "none"))
    )
  )
)

# perform expensive computations in this "global store"
# these computations are cached in a globally available
# redis memory store which is available across processes
# and for all time.
# @cache.memoize()

global_store <- function(value) {
  print(paste(c('Computing value with', value)), collapse = " ")
  # Sys.sleep(5)
  df[df['category'] == value, ]
}

generate_figure <- function(value, figure) {
  fig <- figure
  filtered_dataframe <- global_store(value)
  fig$data[[1]]$x <- filtered_dataframe$x
  fig$data[[1]]$y <- filtered_dataframe$y
  
  fig$layout <- list(margin = list(l = 20, r = 10, b = 20, t = 10))
  
  fig
}

app$callback(
  output(id = 'signal', property = 'children'),
  list(input(id = 'dropdown', property = 'value')),
  function(value) {
    # compute value and send a signal when done
    global_store(value)
    
    value
  }
)

app$callback(
  output(id = 'graph-1', property = 'figure'),
  list(input(id = 'signal', property = 'children')),
  function(value) {
    # generate_figure gets data from `global_store`.
    # the data in `global_store` has already been computed
    # by the `compute_value` callback and the result is stored
    # in the global redis cached
    
    generate_figure(value, 
                    figure = list(
                      data = list(
                        list(
                          type = "scatter", 
                          mode = "markers", 
                          marker = list(
                            opacity = 0.5,
                            size = 14,
                            line = list(border = "thin darkgrey solid")
                          )
                        )
                      )
                    )
    )
  }
)

app$callback(
  output(id = 'graph-2', property = 'figure'),
  list(input(id = 'signal', property = 'children')),
  function(value) {
  
    generate_figure(value, 
                    figure = list(
                      data = list(
                        list(
                          type = "scatter", 
                          mode = "lines", 
                          line = list(
                            shape = "spline",
                            width = 0.5
                          )
                        )
                      )
                    )
    )
  }
)

app$callback(
  output(id = 'graph-3', property = 'figure'),
  list(input(id = 'signal', property = 'children')),
  function(value) {
    
    generate_figure(value, 
                    figure = list(
                      data = list(
                        list(
                          type = "histogram2d"
                        )
                      )
                    )
    )
  }
)

app$callback(
  output(id = 'graph-4', property = 'figure'),
  list(input(id = 'signal', property = 'children')),
  function(value) {
    
    generate_figure(value, 
                    figure = list(
                      data = list(
                        list(
                          type = "histogram2dcontour" 
                        )
                      )
                    )
    )
  }
)

app$run_server()
