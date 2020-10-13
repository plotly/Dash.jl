library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccDatePickerRange(
        id='my-date-picker-single',
        min_date_allowed=as.Date('1995-8-5'),
        max_date_allowed=as.Date('2017-9-19'),
        initial_visible_month=as.Date('2017-8-5'),
        end_date = as.Date('2017-8-5')
      ),
      htmlDiv(id='output-container-date-picker-range')
    )
  )
)

app$callback(
  output = list(id='output-container-date-picker-range', property = 'children'),
  params = list(input(id = 'my-date-picker-range', property = 'start_date'),
                input(id = 'my-date-picker-range', property = 'end_date')),
  function(start_date, end_date){
    string_prefix = 'You have selected: '

    if(is.null(start_date) == FALSE){
      start_date = format(as.Date(start_date), format = '%B %d,%Y')
      string_prefix = paste(string_prefix, 'Start Date ', start_date, sep = "")
    }
    if(is.null(end_date) == FALSE){
      end_date = format(as.Date(end_date), format = '%B %d,%Y')
      string_prefix = paste(string_prefix, 'End Date: ', end_date, sep = "")

    }
    if(nchar(string_prefix) == nchar('You have selected: ')){
      return('Select a date to see it displayed here')
    }
    else{
      return(string_prefix)
    }
  }

)

app$run_server()
