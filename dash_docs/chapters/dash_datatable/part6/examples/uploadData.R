library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)
library(jsonlite)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccUpload(
        id = 'datatable-upload',
        children = htmlDiv(
          list(
            'Drag and Drop or ',
            htmlA('Select Files')
          )
        ),
        style = list(
          width = '100%', 
          height = '60px', 
          lineHeight = '60px',
          borderWidth = '1px', 
          borderStyle = 'dashed',
          borderRadius = '5px', 
          textAlign = 'center', 
          margin = '10px'
        )
      ),
      dashDataTable(id = 'datatable-upload-container'),
      dccGraph(id = 'datatable-upload-graph')
    )
  )
)

app$callback(
  output = list(id = 'datatable-upload-container', property = 'data'),
  params = list(input(id = 'datatable-upload', property = 'contents'),
                input(id = 'datatable-upload', property = 'filename')),
  function(contents, filename) {
    if(!is.null(unlist(contents))) {
      dec <- jsonlite::base64_dec(contents)
      
      rawData <- lapply(strsplit(rawToChar(dec), split =  "\r\n")[[1]], 
                        function(raw) {
                          as.numeric(strsplit(raw, split =  ",")[[1]])
                        })
      df <- as.data.frame(na.omit(do.call(rbind, rawData)))
      df_to_list(df)
    } else list()
  }
)

app$callback(
  output = list(id = 'datatable-upload-graph', property = 'figure'),
  params = list(input(id = 'datatable-upload-container', property = 'data')),
  function(rows) {
    
    figure <- if(length(rows) > 0) {
      
      df <- as.data.frame(do.call(rbind, rows))
      p <- dim(df)[2]
      
      if(p == 1) {
        # histogram
        list(
          data = list(
            list(
              x = unlist(df$V1),
              type = 'histogram'
            )
          )
        )
      } else {
        # pick the first two variables
        list(
          data = list(
            list(
              x = unlist(df$V1),
              y = unlist(df$V2),
              opacity=0.7,
              mode = 'markers',
              marker = list(size = 15,
                            line = list(width = 0.5, color = 'white'))
            )
          )
        )
      }
    } else list()
    
    return(figure)
  }
)

app$run_server()
