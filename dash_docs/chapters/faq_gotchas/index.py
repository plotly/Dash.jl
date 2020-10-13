# -*- coding: utf-8 -*-
import os

import dash_core_components as dcc
import dash_html_components as html


from dash_docs import tools
from dash_docs import reusable_components as rc



layout = html.Div([
    rc.Markdown('''
    # FAQs

    <blockquote>
    This is the 6th and final chapter of the essential
    <dccLink children="Dash Tutorial" href="/"/>.
    The <dccLink children="previous chapter" href="/sharing-data-between-callbacks"/>
    described how to share data between callbacks.
    The <dccLink children="rest of the Dash documentation" href="/"/>
    covers other topics like multi-page apps and component libraries.
    </blockquote>

    ## Frequently Asked Questions

    **Q:** *How can I customize the appearance of my Dash app?*

    **A:** Dash apps are rendered in the browser as modern standards-compliant
      web apps. This means that you can use CSS to style your Dash app as you
      would standard HTML.

      All `dash-html-components` support inline CSS styling through a `style`
      attribute. An external CSS stylesheet can also be used to style
      `dash-html-components` and `dash-core-components` by targeting the ID or
      class names of your components. Both `dash-html-components` and
      `dash-core-components` accept the attribute `className`, which corresponds
      to the HTML element attribute `class`.

      The <dccLink children="Dash HTML Components" href="/dash-html-components"/>
      section in the Dash User
      Guide explains how to supply `dash-html-components` with both inline
      styles and CSS class names that you can target with CSS style sheets. The
      <dccLink children="Adding CSS & JS and Overriding the Page-Load
      Template" href="/external-resources"/> section in the Dash Guide explains how you
      can link your own style sheets to Dash apps.

    ------------------------

    **Q:** *How can I add JavaScript to my Dash app?*

    **A:** You can add your own scripts to your Dash app, just like you would
      add a JavaScript file to an HTML document. See the <dccLink children="Adding CSS & JS and
      Overriding the Page-Load Template" href="/external-resources"/> section in the
      Dash Guide.

    ------------------------

    **Q:** *Can I make a Dash app with multiple pages?*

    **A:** Yes! Dash has support for multi-page apps. See the <dccLink children="Multi-Page Apps
      and URL Support" href="/urls"/> section in the Dash User Guide.

    ------------------------

    **Q:** *How I can I organise my Dash app into multiple files?*

    **A:** A strategy for doing this can be found in the <dccLink children="Multi-Page Apps
      and URL Support" href="/urls"/> section in the Dash User Guide.

    ------------------------

    **Q:** *How do I determine which `Input` has changed?*

    **A:** See `dash.callback_context` in the <dccLink children="Advanced Callbacks" href="/advanced-callbacks"/>
    section.

    ------------------------

    **Q:** *Can I use Jinja2 templates with Dash?*

    **A:** Jinja2 templates are rendered on the server (often in a Flask app)
      before being sent to the client as HTML pages. Dash apps, on the other
      hand, are rendered on the client using React. This makes these
      fundamentally different approaches to displaying HTML in a browser, which
      means the two approaches can't be combined directly. You can however
      integrate a Dash app with an existing Flask app such that the Flask app
      handles some URL endpoints, while your Dash app lives at a specific
      URL endpoint.

    ------------------------

    **Q:** *Can I use jQuery with Dash?*

    **A:** For the most part, you can't. Dash uses React to render your app on
      the client browser. React is fundamentally different to jQuery in that it
      makes use of a virtual DOM (Document Object Model) to manage page
      rendering. Since jQuery doesn't speak React's virtual DOM, you can't use
      any of jQuery's DOM manipulation facilities to change the page layout,
      which is frequently why one might want to use jQuery. You can however use
      parts of jQuery's functionality that do not touch the DOM, such as
      registering event listeners to cause a page redirect on a keystroke.

    In general, if you are looking to add custom clientside behavior in your
    application, we recommend encapsulating that behavior in a
    <dccLink children="custom Dash component" href="/plugins"/>.

    ------------------------

    **Q:** *Where did those cool undo and redo buttons go?*

    **A:** OK, mostly we got the opposite question:
    [How do I get rid of the undo/redo buttons](https://community.plotly.com/t/is-it-possible-to-hide-the-floating-toolbar/4911/10).
    While this feature is neat from a technical standpoint most people don't
    find it valuable in practice. As of Dash 1.0 the buttons are removed by
    default, no hacky CSS tricks needed. If you want them back, use
    `show_undo_redo`:

    `app = Dash(show_undo_redo=True)`

    ------------------------

    **Q:** *I have more questions! Where can I go to ask them?*

    **A:** The [Dash Community forums](https://community.plotly.com/c/dash) is full
      of people discussing Dash topics, helping each other with questions, and
      sharing Dash creations. Jump on over and join the discussion.

  ''')
])
