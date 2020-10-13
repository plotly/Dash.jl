library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)
library(anytime)

app <- Dash$new()

app$layout(htmlDiv(list(
  dccUpload(
    id='upload-data',
    children=htmlDiv(list(
      'Drag and Drop or ',
      htmlA('Select Files')
    )),
    style=list(
      'width'= '100%',
      'height'= '60px',
      'lineHeight'= '60px',
      'borderWidth'= '1px',
      'borderStyle'= 'dashed',
      'borderRadius'= '5px',
      'textAlign'= 'center',
      'margin'= '10px'
    ),
    # Allow multiple files to be uploaded
    multiple=TRUE
  ),
  htmlDiv(id='output-data-upload')
)))

parse_contents = function(contents, filename, date){
  content_type = strsplit(contents, ",")
  content_string = strsplit(contents, ",")
  decoded = base64_dec(content_string)
  
  if('csv' %in% filename){
    df = read.csv(utf8::as_utf8(decoded))
  } else if('xls' %in% filename){
    df = read.table(decoded, encoding = 'bytes')
  } else{
    return(htmlDiv(list(
      'There was an error processing this file.'
    )))
  }
  
  return(htmlDiv(list(
    htmlH5(filename),
    htmlH6(anytime(date)),
    dashDataTable(df_to_list('records'),columns = lapply(colnames(df), function(x){list('name' = x, 'id' = x)})),
    htmlHr(),
    htmlDiv('Raw Content'),
    htmlPre(paste(substr(toJSON(contents), 1, 100), "..."), style=list(
      'whiteSpace'= 'pre-wrap',
      'wordBreak'= 'break-all'
    ))
  )))
}

app$callback(
  output = list(id='output-data-upload', property = 'children'),
  params = list(input(id = 'upload-data', property = 'contents'),
                state(id = 'upload-data', property = 'filename'),
                state(id = 'upload-data', property = 'last_modified')),
  function(list_of_contents, list_of_names, list_of_dates){
    if(is.null(list_of_contents) == FALSE){
      children = lapply(1:length(list_of_contents), function(x){
        parse_content(list_of_contents[[x]], list_of_names[[x]], list_of_dates[[x]])
      })
      
    }
    return(children)
  })

app$run_server()








