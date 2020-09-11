import pathlib
import os.path
import logging
import dash.testing.wait as wait
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_devtools_ui", filename)

def test_jldvui001_disable_props_check_config(dashjl):
    fp = jl_test_file_path("jldvui001_disable_props_check_config.jl")
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal("#tcid", "Hello Props Check", timeout = 10)
    assert dashjl.find_elements("#broken svg.main-svg"), "graph should be rendered"

    assert dashjl.find_elements(
        ".dash-debug-menu"
    ), "the debug menu icon should show up"

def test_jldvui002_disable_ui_config(dashjl):
    fp = jl_test_file_path("jldvui002_disable_ui_config.jl")
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal("#tcid", "Hello Disable UI", timeout = 10)
    logs = str(wait.until(dashjl.get_logs, timeout=2))
    assert (
        "Invalid argument `animate` passed into Graph" in logs
    ), "the error should present in the console without DEV tools UI"

    assert not dashjl.find_elements(
        ".dash-debug-menu"
    ), "the debug menu icon should NOT show up"