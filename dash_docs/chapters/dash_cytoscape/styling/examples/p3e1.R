# Phylogeny tree inspired from: http://www.bio.miami.edu/dana/106/106F06_10.html

library(dash)
library(dashHtmlComponents)
library(dashCytoscape)
library(stringr)

app <- Dash$new()

# Creating elements
nonterminal_nodes <- lapply(
  list(
    'animalia',
    'eumetazoa',
    'bilateria',
    'deuterostomia'
  ),
  function(name) {
    return(
      list(
        'data' = list(
          'id' = name, 
          'label' = toupper(name)
        ), 
        'classes' = 'nonterminal'
      )
    )
  }
)
terminal_nodes <- lapply(
  list(
    list('porifera', '4/45/Spongilla_lacustris.jpg'),
    list('ctenophora', 'c/c8/Archaeocydippida_hunsrueckiana.JPG'),
    list('cnidaria', 'c/c1/Polyps_of_Cnidaria_colony.jpg'),
    list('acoela', 'a/aa/Waminoa_on_Plerogyra.jpg'),
    list('echinodermata', '7/7a/Ochre_sea_star_on_beach%2C_Olympic_National_Park_USA.jpg'),
    list('chordata', 'd/d6/White_cockatoo_%28Cacatua_alba%29.jpg')
  ),
  function(node) {
    names(node) <- list('name', 'url')
    return(
      list(
        'classes' = 'terminal',
        'data' = list(
          'id' = node$name,
          'label' = toupper(node$name),
          'url' = paste('https://upload.wikimedia.org/wikipedia/commons/thumb/', node$url, '/150px-', 
                        tail(str_split(node$url, '/')[[1]], n=1), sep="")
        )
      )
    )
  }
)
edges <- lapply(
  list(
    list('animalia', 'porifera'),
    list('animalia', 'eumetazoa'),
    list('eumetazoa', 'ctenophora'),
    list('eumetazoa', 'bilateria'),
    list('eumetazoa', 'cnidaria'),
    list('bilateria', 'acoela'),
    list('bilateria', 'deuterostomia'),
    list('deuterostomia', 'echinodermata'),
    list('deuterostomia', 'chordata')
  ),
  function(edge) {
    names(edge) <- list('source', 'target')
    return(
      list(
        'data' = list(
          'source' = edge$source, 
          'target' = edge$target
        )
      )
    )
  }
)

# Creating styles
stylesheet <- list(
  list(
    'selector' = 'node',
    'style' = list(
      'content' = 'data(label)'
    )
  ),
  list(
    'selector' = '.terminal',
    'style' = list(
      'width' = 90,
      'height' = 80,
      'background-fit' = 'cover',
      'background-image' = 'data(url)'
    )
  ),
  list(
    'selector' = '.nonterminal',
    'style' = list(
      'shape' = 'rectangle'
    )
  )
)

# Declare app layout
app$layout(
  htmlDiv(
    list(
      # Block 10: Displaying Images
      cytoCytoscape(
        id = 'cytoscape-images',
        layout = list('name' = 'breadthfirst', 'roots' = list('animalia')),
        style = list('width' = '100%', 'height' = '550px'),
        stylesheet = stylesheet,
        elements = c(terminal_nodes, nonterminal_nodes, edges)
      )
    )
  )
)

app$run_server()
