import dash_core_components as dcc
from dash_docs import reusable_components as rc

layout = rc.Markdown(
    '''
    # Encapsulating D3.js Charts as Python Dash Components

    D3.js is a flexible library for rendering and animating SVG in the web
    browser. It's approach toward rendering content in the DOM is quite
    different than React.js, the user interface library that Dash components
    use.

    By popular demand, we've created a set of tutorials to help you
    make high quality Dash components with D3.js. Beyond D3, these
    tutorials should also help you better understand how to integrate
    3rd-party libraries into your custom React and Dash components.

    - Tutorial 1 - [React + D3.js, Guiding Principles](https://gist.github.com/alexcjohnson/a4b714eee8afd2123ee00cb5b3278a5f)
    - Tutorial 2 - [Real World Example: Dash Sunburst](https://github.com/plotly/dash-sunburst)
    - Tutorial 3 - [Real World Example: Dash Network](https://github.com/plotly/dash-network)

    Questions or feedback? Let us know in our [Dash + D3 Feedback Thread](https://github.com/plotly/dash-docs/issues/242)

    > Note: Before you dig in too deep into D3.js, we recommend checking out
    > [`plotly.js`](https://github.com/plotly/plotly.js), our flagship
    > open source charting library. Since 2012, we've worked hard to abstract
    > away the complexity of data visualization through a standard, declarative
    > interface for over 30 chart types. Under the hood, `plotly.js` uses
    > D3.js and WebGL. `dash_core_components.Graph` is the official
    > Dash interface to `plotly.js`.

    '''
)
