import pathlib
import os.path
import logging
import os
from time import sleep
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
RED_BG = """
#hot-reload-content {
    background-color: red;
}
"""
reload_js = """
document.getElementById('tested').innerHTML  = 'Reloaded';
"""

reload_jl = """
using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash()
app.layout = html_div(id="after-reload-content") do
    html_h3("Hot restart"),
    dcc_input(id="input", value="init"),
    html_div(id="output")
end

callback!(app, Output("output","children"), Input("input","value")) do value
    return "after reload $value"
end

run_server(app,
        dev_tools_hot_reload=true,
        dev_tools_hot_reload_interval=0.1,
        dev_tools_hot_reload_watch_interval=0.1,
        dev_tools_hot_reload_max_retry=100
        )
"""

def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_hot_reload", filename)


def test_jldvhr001_hot_reload(dashjl):
    fp = jl_test_file_path("jldvhr001_hot_reload.jl")
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal(
        "#tested", "Initial", timeout = 4
    )

    # default overload color is blue
    dashjl.wait_for_style_to_equal(
        "#hot-reload-content", "background-color", "rgba(0, 0, 255, 1)"
    )

    hot_reload_file = os.path.join(
        os.path.dirname(__file__), "jl_hot_reload", "hr_assets", "hot_reload.css"
    )

    with open(hot_reload_file, "r+") as fp:
        sleep(1)  # ensure a new mod time
        old_content = fp.read()
        fp.truncate(0)
        fp.seek(0)
        fp.write(RED_BG)

    try:
        # red is live changed during the test execution
        dashjl.wait_for_style_to_equal(
            "#hot-reload-content", "background-color", "rgba(255, 0, 0, 1)"
        )
    finally:
        sleep(1)  # ensure a new mod time
        with open(hot_reload_file, "w") as f:
            f.write(old_content)

    dashjl.wait_for_style_to_equal(
        "#hot-reload-content", "background-color", "rgba(0, 0, 255, 1)"
    )

    dashjl.wait_for_text_to_equal(
        "#tested", "Initial", timeout = 2
    )

    hot_reload_js_file = os.path.join(
        os.path.dirname(__file__), "jl_hot_reload", "hr_assets", "hot_reload.js"
    )

    with open(hot_reload_js_file, "r+") as fp:
        sleep(1)  # ensure a new mod time
        old_content = fp.read()
        fp.truncate(0)
        fp.seek(0)
        fp.write(reload_js)

    try:
        dashjl.wait_for_text_to_equal(
            "#tested", "Reloaded"
        )
    finally:
        sleep(1)  # ensure a new mod time
        with open(hot_reload_js_file, "w") as f:
            f.write(old_content)

    dashjl.wait_for_text_to_equal(
        "#tested", "Initial"
    )
def test_jldvhr002_hot_restart(dashjl):
    app_file = jl_test_file_path("jldvhr002_hot_restart.jl")
    dashjl.start_server(app_file)

    dashjl.wait_for_element_by_css_selector(
        "#before-reload-content", timeout=4
    )

    dashjl.wait_for_text_to_equal(
        "#output", "before reload initial", timeout=2
    )
    input_ = dashjl.find_element("#input")
    dashjl.clear_input(input_)
    input_.send_keys("test")

    dashjl.wait_for_text_to_equal(
        "#output", "before reload test", timeout=2
    )


    with open(app_file, "r+") as fp:
        sleep(1)  # ensure a new mod time
        old_content = fp.read()
        fp.truncate(0)
        fp.seek(0)
        fp.write(reload_jl)

    try:
        dashjl.wait_for_element_by_css_selector(
            "#after-reload-content", timeout=30
        )

        dashjl.wait_for_text_to_equal(
            "#output", "after reload init", timeout=1
        )
        input_ = dashjl.find_element("#input")
        dashjl.clear_input(input_)
        input_.send_keys("test")

        dashjl.wait_for_text_to_equal(
            "#output", "after reload test", timeout=1
        )
    finally:
        sleep(1)  # ensure a new mod time
        with open(app_file, "w") as f:
            f.write(old_content)
