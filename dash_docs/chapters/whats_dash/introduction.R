

utils <- new.env()
source('dash_docs/utils.R', local=utils)

layout = htmlDiv(list(
  htmlH2("Introduction to Dash"),

  dccMarkdown("
Dash is a productive framework for building web applications in both R and Python.

Written on top of Fiery/Flask, Plotly.js, and React.js,
Dash is ideal for building data visualization apps
with highly custom user interfaces in pure R or Python.
It's particularly suited for anyone who works with data.

Through a couple of simple patterns, Dash abstracts away all of the
technologies and protocols that are required to build an
interactive web-based application.
Dash is simple enough that you can bind a user interface
around your R or Python code in an afternoon.

Dash apps are rendered in the web browser. You can deploy your apps
to servers and then share them through URLs.
Since Dash apps are viewed in the web browser, Dash is inherently
cross-platform and mobile ready.

There is a lot behind the framework. To learn more about how the original Dash was built
and what motivated Dash, watch our talk from
Plotcon below
or read our [announcement letter](https://medium.com/@plotlygraphs/introducing-dash-5ecf7191b503).

Dash is an open source library, released under the permissive MIT license.
[Plotly](https://plotly.com) develops Dash for R and offers a
[platform for managing Dash for R & Python apps in an enterprise environment](https://plotly.com/dash).
If you're interested, [please get in touch](https://plot.ly/get-demo).

***

  "),

    htmlIframe(
        width='100%',
        height='480',
        style=list('border' = 'none'),
        src='https://www.youtube-nocookie.com/embed/5BAthiN0htc?rel=0'
    )
  ))
