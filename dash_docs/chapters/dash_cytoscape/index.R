library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashCytoscape)

utils <- new.env()
source('dash_docs/utils.R', local=utils)
components <- new.env()
source('dash_docs/components.R', local=components)

examples <- list(
  quickStart = utils$LoadExampleCode('dash_docs/chapters/dash_cytoscape/examples/quickStart.R')
)

layout <- htmlDiv(list(
  htmlH1("Dash Cytoscape"),
  htmlIframe(
    src = "https://ghbtns.com/github-btn.html?user=plotly&repo=dash-cytoscape&type=star&count=true&size=large",
    width = "160px",
    height = "30px",
    style = list('border' = 'none')
  ),
  dccMarkdown("
  > New! Released on February 5th, 2019
  >
  > Dash Cytoscape is a graph visualization component for creating easily customizable,
  > high-performance, interactive, and web-based networks. It extends and renders
  > [Cytoscape.js](http://js.cytoscape.org/),
  > and offers deep integration with Dash layouts and callbacks, enabling the creation
  > of powerful networks in conjunction with the rich collection of Dash components.
  "),
  # EDIT: as well as established computational biology and network science libraries such as Biopython and networkX.

  components$Header("Quickstart"),
  # Block 0.1
  examples$quickStart$source,
  examples$quickStart$layout,

  components$Header("Dash Cytoscape User Guide"),
  dccMarkdown("
  > Dash Cytoscape graphs are interactive! Scroll to zoom and drag on the canvas to
  > move the entire graph around. You can move nodes by dragging it, or by clicking,
  > holding, and moving your mouse to the desired location (and click again to release).
  >
  > This also work in mobile! Tap-and-hold on a node to move it, or on the canvas to
  > move the entire graph. Pinch your fingers outwards to zoom in, or pinch them together
  > to zoom out.
  "),
  components$Chapter(
  "Part 1: Elements",
  "cytoscape/elements",
  "
  Elements in Cytoscape are designed to be clear, simple and
  declarative. This chapter will get you started with examples
  for:
  - Data and position named lists
  - Mutability properties
  - Defining groups and classes
  - Compound nodes
  "
  ),
  components$Chapter(
  "Part 2: Layout",
  "cytoscape/layout",
  "
  Make your graphs interpretable by using the built-in collection of easy-to-modify
  layouts. We show you how to:
  * Display pre-determined and random layouts
  * Represent your graph as a circle, a grid or a tree
  * Finetune your representations by modifying the default options
  * Use physics-based simulations to generate your layout
  "
  ),
  components$Chapter(
  "Part 3: Styling",
  "cytoscape/styling",
  "
  Modify the color, shape and style of your elements with a syntax similar to CSS.
  Cytoscape includes a wide variety of properties, equiping you with everything you
  need to display your graphs with aesthetics, creativity, and understandability in
  mind. This chapter covers:
  * Basic style properties for nodes and edges
  * Using selectors to modify specific groups of elements
  * Organize your edges with curve and line properties
  * Advanced node styling with pie charts and images
  "
  ),
  components$Chapter(
  "Part 4: Dash Callbacks",
  "cytoscape/callbacks",
  "
  Update your layout, elements, or style with other Dash components using callbacks.
  This chapter covers:
  * Adding and removing elements
  * Modifying the layout and the stylesheet
  * Advanced usage of callbacks
  "
  ),
  components$Chapter(
  "Part 5: Event Callbacks for User Interactions",
  "cytoscape/events",
  "
  Dash Cytoscape fires callbacks whenever the user interact with the graph you created,
  which can be used to update the graph itself, or to interact with other components.
  This chapter includes examples for:
  * Simple integrations with HTML components
  * Different types of data returned
  * Node versus edges callbacks
  * Tap, hover or select callbacks
  "
  ),
  components$Chapter(
  "Part 6: Component Reference",
  "cytoscape/reference",
  "
  You can find here all the properties of the Cytoscape component.
  "
  ),
  # components$Chapter(
  # "Part 6: Cytoscape for Phylogeny Trees",
  # "cytoscape/phylogeny",
  # "
  # We show how Dash Cytoscape can be applied can be applied in bioinformatics and
  # computational biology. We will go through the process of building a phylogeny tree
  # using relevant packages in R.
  # "
  # ),
  # components$Chapter(
  # "Part 7: Component Reference",
  # "cytoscape/reference",
  # "
  # You can find here all the properties of the Cytoscape component.
  # "
  # ),

  components$Header("Roadmap, Sponsorships, and Contact"),
  dccMarkdown("
  In the near future, we would like to support integration with some graphing packages,
  expand object-oriented declarations, and offer more support for layout options. Check
  out our [open issues](https://github.com/plotly/dash-cytoscape/issues) for more details.

  The development for this component was sponsored by one of our commercial partners.
  Interested in steering the roadmap?
  [Get in touch](https://plotly.com/products/consulting-and-oem/?_ga=2.67745489.1119063560.1560730925-1013488808.1557293663).
  "),

  htmlHr(),
  dccMarkdown("[Back to the Table of Contents](/)")
))
