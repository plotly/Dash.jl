# Dash for Julia

[![CircleCI](https://circleci.com/gh/plotly/Dash.jl/tree/master.svg?style=svg)](https://circleci.com/gh/plotly/Dash.jl/tree/master)
[![GitHub](https://img.shields.io/github/license/plotly/dashR.svg?color=dark-green)](https://github.com/plotly/Dash.jl/blob/master/LICENSE)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/plotly/Dash.jl.svg?color=dark-green)](https://github.com/plotly/Dash.jl/graphs/contributors)

#### *Dash is a Julia framework for building analytical web applications. No JavaScript required*.

Built on top of Plotly.js, React and HTTP.jl, Dash ties modern UI elements like dropdowns, sliders, and graphs directly to your analytical Julia code. Read our tutorial proudly crafted ❤️ by Dash itself.

- [User Guide](https://dash-julia.plotly.com/getting-started)

### Contact and Support

For companies with software budgets, Plotly offers

- [**Dash Deployment Server**](https://plotly.com/products/dash/) speeds your time-to-delivery while providing the right resources, security, and scalability you need to deliver production-quality apps
- [**Dash Design Kit**](https://plotly.com/products/dash/) makes your internal dashboard awesome without expertise in JavaScript & CSS.
- [**Snapshot Engine**](https://plotly.com/products/dash/) seamlessly links your analytics and reporting workflows together, giving you a fast way to generate interactive reports of just the data you need

See [https://plotly.com/dash/support](https://plotly.com/dash/support) for ways to get in touch.

## Installation

Please ensure that you are using a version of Julia >= 1.2.

To install the most recently released version:

```julia
pkg> add Dash DashCoreComponents DashHtmlComponents DashTable
```

To install the latest (stable) development version instead:

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/plotly/DashBase.jl.git"))
Pkg.add(PackageSpec(url="https://github.com/plotly/dash-html-components.git", rev="master"))
Pkg.add(PackageSpec(url="https://github.com/plotly/dash-core-components.git", rev="master"))
Pkg.add(PackageSpec(url="https://github.com/plotly/dash-table.git", rev="master"))
Pkg.add(PackageSpec(url="https://github.com/plotly/Dash.jl.git", rev="dev"))
```

## Usage

See the [User Guide](https://dash-julia.plotly.com/getting-started).
