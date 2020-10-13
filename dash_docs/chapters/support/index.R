library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

utils <- new.env()
source('dash_docs/utils.R', local=utils)

layout = htmlDiv(list(dccMarkdown("
# Dash Support and Contact
Dash is an open-source product that is
developed and maintained by [Plotly](https://plotly.com).
### Dash Demos and Enterprise Trials
If you would like to trial or purchase Dash Enterprise,
[get in touch with us directly](https://plotly.typeform.com/to/rkO85m).
Our sales engineering team is happy to give you or your team
a demo of Dash and Dash Enterprise too.

### Sponsored Feature Requests and Customizations

If you or your company would like to sponsor a specific feature or enterprise
customization, get in touch with our
[advanced development team](https://plotly.com/products/consulting-and-oem).
### Community Support
Our community forum at [community.plotly.com](https://community.plotly.com) has
a topic dedicated on [Dash](https://community.plotly.com/c/dash).
This forum is great for showing off projects, feature requests,
and general questions.
If you have found a bug, you can open an issue on GitHub at
[plotly/dash](https://github.com/plotly/dash).

### Direct Contact
If you would like to reach out to me directly,
you can email me at <chris@plotly.com> or on
Twitter at [@chriddyp](https://twitter.com/chriddyp).
Plotly is also on Twitter at [@plotlygraphs](https://twitter.com/plotlygraphs).
We are based in Montréal, Canada and our headquarters are in the Mile End.
If you're in the neighborhood, come say hi!"),
                      
htmlBr(),
htmlHr(),
dccMarkdown("[Back to the Table of Contents](/)")
)
)
