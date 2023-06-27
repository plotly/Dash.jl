import pathlib
import os.path
import logging
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_simple_app", filename)

def test_jlstr001_jl_with_string(dashjl):
    fp = jl_test_file_path("jlstr001_jl_with_string.jl")
    dashjl.start_server(fp)
    dashjl.wait_for_text_to_equal(
        "#container", "Hello Dash.jl testing", timeout=10
    )
