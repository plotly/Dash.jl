# Change Log for Dash for Julia
All notable changes to this project will be documented in this file. This project adheres to Semantic Versioning.



### [UNRELEASED]
### Added
- Support for hot reloading on application or asset changes [#25](https://github.com/plotly/Dash.jl#25)
- Asset serving of CSS, JavaScript, and other resources [#18](https://github.com/plotly/Dash.jl/pull/18)
- Support for passing functions as layouts [#18](https://github.com/plotly/Dash.jl/pull/18)
- Resource registry for component assets [#18](https://github.com/plotly/Dash.jl/pull/18)
- Asynchronous component loading & fingerprinting component assets [#18](https://github.com/plotly/Dash.jl/pull/18)
- Developer tools UI support [#18](https://github.com/plotly/Dash.jl/pull/18)
- Dash environment variables are now supported [#18](https://github.com/plotly/Dash.jl/pull/18)
- Index page/layout validation now performed [#18](https://github.com/plotly/Dash.jl/pull/18)
- Support for `gzip` compression [#14](https://github.com/plotly/Dash.jl#14)
- Parity with core Dash API parameters [#12](https://github.com/plotly/Dash.jl/pull/12)
- Integration tests are now supported, server startup message appears on app initialization [#21](https://github.com/plotly/Dash.jl/pull/21)

### Changed
- Dash.jl now starts via `run_server` with `host` and `port` arguments [#2](https://github.com/plotly/Dash.jl/issues/2)
- Defining layouts in Dash.jl now occurs similarly to Dash for Python/R [#1](https://github.com/plotly/Dash.jl/issues/1)

### Removed
- `make_handler` no longer used to start Dash server [#2](https://github.com/plotly/Dash.jl/issues/2)
- `layout_maker` has been removed [#18](https://github.com/plotly/Dash.jl/pull/18)
- `layout_maker` is no longer called by the app developer to define the layout [#1](https://github.com/plotly/Dash.jl/issues/1)

### Fixed
- Request headers are now properly specified [#28](https://github.com/plotly/Dash.jl/issues/28)
- Unspecified `children` now passed as `nothing` rather than undefined [#27](https://github.com/plotly/Dash.jl/issues/27)
