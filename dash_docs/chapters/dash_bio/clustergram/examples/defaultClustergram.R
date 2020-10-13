
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(heatmaply)
library(data.table)

app <- Dash$new()

df = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv",
                        skip = 4, sep ="\t",  row.names = 1, header = TRUE)

# The following lines generate the options list for the dropdown we will be using.
all_options <- rownames(df)

options_list <- list()

for (x in 1:length(all_options)){
  option = list("label" = all_options[x], "value" = all_options[x])
  options_list[[x]] = option
}


app$layout(htmlDiv(list(
  "Rows to display: ",
  dccDropdown(
    id = 'rows-to-display',
    options = options_list,
    value = c("Mazda RX4", "Valiant"),
    multi = TRUE
  ),

  htmlDiv(id = "default-clustergram-output")

)))

app$callback(
  output(id = "default-clustergram-output", property = "children"),
  params = list(
    input(id = 'rows-to-display', property = "value")
  ),

  update_clustergram <- function(value) {
    if (length(value) < 2) {
      return("Please select at least two rows to display.")
    }
    else{

      df <- subset(df, rownames(df) %in% value)
      return(
        dccGraph(figure = heatmaply(df,
                                    row_labels = list(row.names(data)),
                                    hide_labels = list("row"),
                                    column_labels = as.list(colnames(data)),
                                    color_threshold = list(
                                      "row" = 150,
                                      "col" = 700
                                    )
          )
        )
      )
    }
  }
)

app$run_server()
