import pathlib
import os.path
import logging

logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_plotly_graph", filename)

def _run_test(dashjl, filename, percy_snapshot_prefix):
    fp = jl_test_file_path(filename)
    dashjl.start_server(fp)
    dashjl.wait_for_element_by_css_selector("#graph", timeout=20)

    dashjl.wait_for_text_to_equal("#status", "first", timeout=10)
    dashjl.percy_snapshot(name=f"{percy_snapshot_prefix} figure layout")

    dashjl.find_element("#draw").click()
    dashjl.wait_for_text_to_equal("#status", "second", timeout=10)
    dashjl.percy_snapshot(name="f{percy_snapshot_prefix} figure callback")


def test_jlpg001_plotly_graph(dashjl):
    _run_test(dashjl, "jlpg001_plotly_graph.jl", "PlotlyBase")

def test_jlpg002_plotlyjs_graph(dashjl):
    _run_test(dashjl, "jlpg002_plotlyjs_graph.jl", "PlotlyJS")



