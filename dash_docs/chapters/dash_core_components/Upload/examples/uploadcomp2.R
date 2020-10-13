library(dashCoreComponents)
library(dashHtmlComponents)
library(dash)
library(anytime)

app <- Dash$new()

app$layout(htmlDiv(list(
  dccUpload(
    id='upload-image',
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
  htmlDiv(id='output-image-upload')
)))

parse_content = function(contents, filename, date){
  return(htmlDiv(list(
    htmlH5(filename),
    htmlH6(anytime(date)),
           htmlImg(src=contents),
           htmlHr(),
           htmlDiv('Raw Content'),
            htmlPre(paste(substr(toJSON(contents), 1, 100), "..."), style=list(
              'whiteSpace'= 'pre-wrap',
              'wordBreak'= 'break-all'
            ))
    )))
}

app$callback(
  output = list(id='output-image-upload', property = 'children'),
  params = list(input(id = 'upload-image', property = 'contents'),
                state(id = 'upload-image', property = 'filename'),
                state(id = 'upload-image', property = 'last_modified')),
  function(list_of_contents, list_of_names, list_of_dates){
    if(is.null(list_of_contents) == FALSE){
      children = lapply(1:length(list_of_contents), function(x){
        parse_content(list_of_contents[[x]], list_of_names[[x]], list_of_dates[[x]])
      })
    } else{
      
    }
    return(children)
  }
)

app$run_server()









