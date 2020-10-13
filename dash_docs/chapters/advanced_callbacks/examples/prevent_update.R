library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)

app <- Dash$new()

app$layout(htmlDiv(list(
  htmlP('Enter a composite number to see its prime factors'),
  dccInput(id='num', type='number', debounce=TRUE, min=1, step=1),
  htmlP(id='err', style=list('color' = 'red')),
  htmlP(id='out')
)))

app$callback(
  output=list(
    output(id='out', property='children'),
    output(id='err', property='children')
  ),
  params = list(
    input(id='num', 'value')
  ),
  show_factors <- function(num) {
    if(is.null(num[[1]])) {
      # It can be used to prevent ALL outputs updating
      return(dashNoUpdate())
    }
    factors = prime_factors(num[[1]])
    if(length(factors) == 1) {
      return(list(dashNoUpdate(), sprintf('%s is prime!', num[[1]])))
    } 
    else {
      return(list(sprintf('%s is %s', num[[1]], paste(factors, collapse = " * ")), ''))
    }
  }
)

prime_factors <- function(num) {
  n <- num
  i <- 2
  out = list()
  
  while(i*i <= n) {
    if(n%%i == 0) {
      n = as.integer(n/i)
      out = append(out, i)
    }
    else {
      if (i == 2) {
        i = i + 1
      }
      else {
        i = 2
      }
    }
  }
  
  out = append(out, n)
  return(unlist(out))
}


app$run_server()
