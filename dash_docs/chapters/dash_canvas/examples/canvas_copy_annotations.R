library(dash)
library(dashHtmlComponents)
library(dashCanvas)
library(jsonlite)

source("dash_docs/chapters/dash_canvas/examples/canvas_utils.R")


filename = 'https://upload.wikimedia.org/wikipedia/commons/e/e4/Mitochondria%2C_mammalian_lung_-_TEM_%282%29.jpg'
canvas_width = 300

info <- filename %>% image_read %>% image_info
shape <- c(info$width, info$height)

app <- Dash$new()

app$layout(htmlDiv(
  list(
    htmlH6('Draw on image and press Save to show annotations geometry'),
    htmlDiv(list(
      dashCanvas(
        id = 'canvas_copy_annot',
        lineWidth = 5,
        filename = filename,
        width = canvas_width
      )), className = 'five columns'),
    htmlDiv(list(htmlImg(id = 'my-image', width = 300)), className = 'five columns')
  ), className = 'row'))

app$callback(
  output = list(id = 'my-image', property = 'src'),
  params = list(input(id = 'canvas_copy_annot', property = 'json_data')),

  function(json){

    if (is.null(json) || is.na(json)) {
      return('nothing')
    } else {
      return(matrix_to_data_url(parse_jsonstring(fromJSON(json)[['objects']])))
    }
  }
)

app$run_server()
