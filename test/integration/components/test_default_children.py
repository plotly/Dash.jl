import pathlib
import os.path
import logging
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_default_children", filename)

def test_jlcmdc001_default_children(dashjl):
    fp = jl_test_file_path("jlcmdc001_default_children.jl")
    dashjl.start_server(fp)
    dashjl.wait_for_element_by_css_selector(
        "#first-inner-div", timeout=10
    )