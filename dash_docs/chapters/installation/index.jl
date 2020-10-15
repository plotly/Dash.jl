module chapters_installation

using Dash, DashHtmlComponents, DashCoreComponents
include("../../reusable_components/Header.jl")

app = dash()

app.layout = html_div() do
    Header("Dash Installation"),
    dcc_markdown("""

    In order to use Dash, please ensure that you are using a version of Julia >= 1.2.

    To install the most recent version:

    ```
        pkg> add Dash DashCoreComponents DashHtmlComponents DashTable
    ```

    To install the latest (stable) development version of Dash instead:

    ```
        using Pkg;
        Pkg.add(PackageSpec(url="https://github.com/plotly/DashBase.jl.git"))
        Pkg.add(PackageSpec(url="https://github.com/plotly/dash-html-components.git", rev="master"))
        Pkg.add(PackageSpec(url="https://github.com/plotly/dash-core-components.git", rev="master"))
        Pkg.add(PackageSpec(url="https://github.com/plotly/dash-table.git", rev="master"))
        Pkg.add(PackageSpec(url="https://github.com/plotly/Dash.jl.git", rev="dev"))
    ```

    Once you have installed Dash, you are ready to [make your first Dash app](/getting-started).

    A quick note on checking your versions and on upgrading.
    These docs are run using the versions listed above and these versions should
    be the latest versions available.
    To check which version that you have installed, you can run:

    ```
    Pkg.status("Dash")
    Pkg.status("DashHtmlComponents")
    Pkg.status("DashCoreComponents")
    ```

    To see the latest changes of any package, check the CHANGELOG.MD file in
    the appropriate GitHub repo.

    * [Dash changelog](https://github.com/plotly/Dash.jl/blob/dev/CHANGELOG.md)
    * [DashCoreComponents changelog](https://github.com/plotly/dash-core-components/blob/master/CHANGELOG.md)
    * [DashHTMLComponents changelog](https://github.com/plotly/dash-html-components/blob/master/CHANGELOG.md)
    * [DashTable changelog](https://github.com/plotly/dash-table/blob/master/CHANGELOG.md)
    """),

    html_hr(),
    dcc_markdown("Ready? Now, [let's make your first Dash app.](/getting-started)"),
    dcc_markdown("[Back to the table of contents](/)")

end

end
