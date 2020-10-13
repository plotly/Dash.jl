library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(rjson)
library(readr)
library(heatmaply)
library(data.table)
library(dashTable)

utils <- new.env()
source('dash_docs/styles.R')
source('dash_docs/utils.R')
source('dash_docs/utils.R', local=utils)

examples <- list(
  defaultClustergram=utils$LoadExampleCode('dash_docs/chapters/dash_bio/clustergram/examples/defaultClustergram.R')
)

dashbio_intro <- htmlDiv(list(
  dccMarkdown('# Clustergram Examples and Reference'),

  dccMarkdown('
  See Clustergram in action [here](https://dash-gallery.plotly.host/dash-clustergram/).
  ')
))

# Individual Components and Examples

defaultClustergram <- htmlDiv(list(
  dccMarkdown('## Default Clustergram'),
  htmlP('An example of a default clustergram component without any extra properties.'),
  htmlDiv(list(
    examples$defaultClustergram$source_code,
    examples$defaultClustergram$layout))
))

heatmapColorScale <- htmlDiv(list(
  dccMarkdown('## Heatmap Color Scale'),
  htmlP('Change the color scale by specifying values and colors.'),
  utils$LoadAndDisplayComponent(
    '
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(heatmaply)
library(data.table)

df = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv",
                        skip = 4, sep ="\t",  row.names = 1, header = TRUE)

dccGraph(figure = heatmaply(df,
                            row_labels = list(row.names(data)),
                            hide_labels = list("row"),
                            column_labels = as.list(colnames(data)),
                            color_threshold = list(
                            "row" = 150,
                            "col" = 700
                            ),
                            colors = BrBG,
                            limits = c(0, 500),
                            midpoint = 200
          )
        )
  '
  )
))


dendrogramColorWidth <- htmlDiv(list(
  dccMarkdown('## Dendrogram Cluster Colors/Line Widths'),
  htmlP('Change the colors of the dendrogram traces that are used to represent clusters, and configure their line widths.'),
  utils$LoadAndDisplayComponent(
    '
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(heatmaply)
library(data.table)

df = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv",
                        skip = 4, sep ="\t",  row.names = 1, header = TRUE)

# The following is a color palette.

rc <- colorspace::rainbow_hcl(nrow(df))

dccGraph(figure = heatmaply(df,
                            row_labels = list(row.names(data)),
                            hide_labels = list("row"),
                            column_labels = as.list(colnames(data)),
                            color_threshold = list(
                            "row" = 250,
                            "col" = 700
                            ),
                            seriate = "mean",
                            RowSideColors = rc,
                            k_col = 2,
                            k_row = 2
          )
        )
  '
  )
))

dendrogramRelativeSize <- htmlDiv(list(
  dccMarkdown('## Relative Dendrogram Size'),
  htmlP('Change the relative width and height of, respectively, the row and column dendrograms compared to the width and height of the heatmap.'),
  utils$LoadAndDisplayComponent(
    '
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(heatmaply)
library(data.table)

df = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv",
                        skip = 4, sep ="\t",  row.names = 1, header = TRUE)

dccGraph(figure = heatmaply(df,
                            row_labels = list(row.names(data)),
                            hide_labels = list("row"),
                            column_labels = as.list(colnames(data)),
                            color_threshold = list(
                            "row" = 250,
                            "col" = 700
                            ),
                            height = 800,
                            width = 700,
                            display_ratio=list(0.1, 0.7)

          )
        )
  '
  )
))

hiddenLabels <- htmlDiv(list(
  dccMarkdown('## Hidden Labels'),
  htmlP('Hide the labels along one or both dimensions.'),
  utils$LoadAndDisplayComponent(
    '
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(heatmaply)
library(data.table)

df = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv",
                        skip = 4, sep ="\t",  row.names = 1, header = TRUE)

dccGraph(figure = heatmaply(df,
                            row_labels = list(row.names(data)),
                            hide_labels = list("row"),
                            column_labels = as.list(colnames(data)),
                            color_threshold = list(
                            "row" = 250,
                            "col" = 700
                            ),
                            showticklabels = c(T,F)

          )
        )
  '
  )
))

heatmapAnnotations <- htmlDiv(list(
  dccMarkdown('## Annotations'),
  htmlP('Annotate the clustergram by highlighting specific clusters.'),
  utils$LoadAndDisplayComponent(
    '
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBio)
library(heatmaply)
library(data.table)

df = read.table("https://raw.githubusercontent.com/plotly/dash-bio-docs-files/master/clustergram_mtcars.tsv",
                        skip = 4, sep ="\t",  row.names = 1, header = TRUE)


dccGraph(figure = heatmaply(df[, -c(8,9)],
                            row_labels = list(row.names(data)),
                            hide_labels = list("row"),
                            column_labels = as.list(colnames(data)),
                            color_threshold = list(
                            "row" = 250,
                            "col" = 700
                            ),
                            seriate = "mean",
                            col_side_colors = c(rep(0,5), rep(1,4)),
                            row_side_colors = df[,8:9],


          )
        )
  '
  )
))

heatmaply_props <- props_to_list("heatmaply")
heatmaplyPropsDF <- rbindlist(heatmaply_props, fill = TRUE)
heatmaply_props_table <- generate_table(heatmaplyPropsDF)

# Main docs layout

layout <- htmlDiv(list(
      dashbio_intro,
      defaultClustergram,
      heatmapColorScale,
      dendrogramColorWidth,
      dendrogramRelativeSize,
      hiddenLabels,
      heatmapAnnotations,
      dccMarkdown('## Clustergram Properties'),
      heatmaply_props_table,
      htmlHr(),
      dccMarkdown("[Back to Dash Bio Documentation](/dash-bio)"),
      dccMarkdown("[Back to Dash Documentation](/)")
))
