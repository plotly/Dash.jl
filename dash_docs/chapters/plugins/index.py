import dash_core_components as dcc
import dash_html_components as html
from dash_docs import reusable_components as rc

layout = rc.Markdown('''
# Writing your own components

One of the really cool things about dash is that
it is built on top of [React.js](https://facebook.github.io/react/),
a JavaScript library for building web components.

The React community is huge. Thousands of components have been built and
released with open source licenses. For example, here are just some of the
[slider components](https://react.rocks/?q=slider) and
[table components](https://react.rocks/?q=tables) that have been published
by the React community, any of which could be adapted into a Dash Component.

## Creating a Component

To create a Dash component, fork our sample component repository and
follow the instructions in the README.md:
[https://github.com/plotly/dash-component-boilerplate](https://github.com/plotly/dash-component-boilerplate)

If you are just getting started with React.js as a Python programmer, please check out our essay
<dccLink href="/react-for-python-developers" children="React for Python Devs"/>.


### How Are Components Converted From React.js to Python?

Dash provides a framework that converts React components
(written in JavaScript) into Python classes that are
compatible with the Dash ecosystem.

On a high level, this is how that works:
- Components in dash are serialized as [JSON](https://www.json.org/).
  To write a dash-compatible component, all of the props
  shared between the Python code and the React code must be serializable as JSON.
  Numbers, Strings, Booleans, or Arrays or Objects containing Numbers, Strings, Booleans.
  For example, JavaScript functions are not valid input arguments.
  In fact, if you try to add a function as a prop to your Dash component, you
  will see that the generated Python code for your component will not include
  that prop as part of your component's accepted list of props.
  (It's not going to be listed in the `Keyword arguments` enumeration or in the
  `self._prop_names` array of the generated Python file for your component).
- By annotating components with React docstrings (not required but helpful
  and encouraged), Dash extracts the information about the component's name,
  properties, and description through [React Docgen](https://github.com/reactjs/react-docgen).
  This is exported as a JSON file (metadata.json).
- At build time, Dash reads this JSON file and dynamically creates Python classes
  that subclass a core Dash component. These classes include argument validation,
  Python docstrings, types, and a basic set of methods. _These classes are
  generated entirely automatically._ A JavaScript developer does not need to
  write _any_ Python in order to generate a component that can be used in the
  Dash ecosystem.
- You will find all of the auto-generated files from the build process in the
  folder named after your component. When you create your Python package, by default any
  non-Python files won't be included in the actual package. To include these files
  in the package, you must list them explicitly in `MANIFEST.in`. That is, `MANIFEST.in`
  needs to contain each JavaScript, JSON, and CSS file that you have included in
  your `my_dash_component/` folder. In the `dash-component-boilerplate` repository,
  you can see that all the javascript for your React component is included in the
  build.js file.
- The Dash app will crawl through the app's `layout` property and check which
  component packages are included in the layout and it will extract that
  component's necessary JavaScript or CSS bundles. Dash will serve these bundles
  to Dash's front-end. These JavaScript bundles are used to render the components.
- Dash's `layout` is serialized as JSON and served to Dash's front-end. This
  `layout` is recursively rendered with these JavaScript bundles and React.


''')
