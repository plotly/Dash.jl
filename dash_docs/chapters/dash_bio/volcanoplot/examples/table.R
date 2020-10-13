library(dash)
library(dashTable)
library(dashBio)

df <- data.frame(
  Attribute = formalArgs(dashbioVolcano)[1:18],
  Description = c("A pandas dataframe which must contain at least the following two columns: - a numeric quantity to plot such as a p-value or zscore - a numeric quantity measuring of the strength of association, typically an odds ratio, regression coefficient or log fold change. It is referred here as `effect size`.",
                  "A string denoting the column name for the float quantity to be plotted on the y-axis. This column must be numeric. This does not have to be a p-value. It can be any numeric quantity such as peak heights, bayes factors, test statistics. If it is not a p-value, make sure to set logp = FALSE.",
                  "A string denoting the column name for the effect size. This column in the dataframe must have numeric values, with no values being missing nor NaN.",
                  "A string denoting the column name for the SNP names (e.g. rs number). More generally, this column could be anything that identifies each point being plotted. For example, in an Epigenomewide association study (EWAS) this could be the probe name or cg number. This column should be a character. This argument is optional, however it is necessary to specify if you want to highlight points on the plot using the highlight argument in the figure method.",
                  "A string denoting the column name for the GENE names. More generally, this could be any annotation information that should be included in the plot.",
                  "Title of the graph.",
                  "Label of the x axis.",
                  "Label of the y axis.",
                  "Size of the points of the Scatter plot.",
                  "Color of the points of the Scatter plot. Can be in any color format accepted by plotly_js graph_objs.",
                  "A boolean which must be False to deactivate the option, or a list/array containing the upper and lower bounds of the effect size values. Significant data points will have lower values than the lower bound, or higher values than the higher bound. Keeping the default value will result in assigning the list -1, 1 to the argument.",
                  "Color of the effect size lines.",
                  "Width of the effect size lines.",
                  "A boolean which must be False to deactivate the option, or a numerical value corresponding to the p-value above which the data points are considered significant.",
                  "Color of the genome wide line. Can be in any color format accepted by plotly_js graph_objs.",
                  "Width of the genome wide line.",
                  "Whether the data points considered significant should be highlighted.",
                  "Color of the data points highlighted because considered as significant Can be in any color format accepted by plotly_js graph_objs. # ... Example 1: Random Volcano Plot ''' dataframe = pd.DataFrame( np.random.randint(0,100,size=(100, 2)), columns='P', 'EFFECTSIZE') fig = create_volcano(dataframe, title='XYZ Volcano plot')"),
  Type = c("dataframe",
           "string",
           "string",
           "string",
           "string",
           "string",
           "string",
           "string",
           "number",
           "string",
           "bool/list",
           "string",
           "number",
           "bool/number",
           "string",
           "number",
           "bool",
           "string"
  ),
  "Default value" = c("NULL", "P", "EFFECTSIZE", "SNP", "GENE",
                      "Volcano   Plot", "None", "-log10(p)", 5,
                      "None", "[-1, 1]", "grey", 2, "-np.log10(5e-8)",
                      "red", 1, "TRUE", "red")
)

app <- Dash$new()

app$layout(
  dashDataTable(
    columns = lapply(colnames(df),
                     function(colName){
                       list(
                         id = colName,
                         name = colName
                       )
                     }),
    data = df_to_list(df),
    style_as_list_view = TRUE,
    style_cell = list(padding = '5px', textAlign = 'center'),
    style_header = list(
      backgroundColor = 'white',
      fontWeight = 'bold'
    ),
    style_data = list(
      whiteSpace = "normal"
    ),
    css = list(
      list(
        selector = '.dash-cell div.dash-cell-value',
        rule = 'display: inline; white-space: inherit; overflow: inherit; text-overflow: inherit;'
      )
    )
  )
)

app$run_server()
