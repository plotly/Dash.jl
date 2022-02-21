import pathlib
import os.path
import logging
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_plotly_graph", filename)




def test_jlpg001_plotly_graph(dashjl):
    fp = jl_test_file_path("jlpg001_plotly_graph.jl")
    dashjl.start_server(fp)
    dashjl.wait_for_element_by_css_selector(
        "#graph", timeout=20
    )

    dashjl.wait_for_text_to_equal("#status", "first", timeout=10)

    dashjl.percy_snapshot(name="PlotlyBase figure layout")

    dashjl.find_element("#draw").click()
    dashjl.wait_for_text_to_equal("#status", "second", timeout=10)

    dashjl.percy_snapshot(name="PlotlyBase figure callback")

def test_jlpg002_plotlyjs_graph(dashjl):
    fp = jl_test_file_path("jlpg002_plotlyjs_graph.jl")
    dashjl.start_server(fp)
    dashjl.wait_for_element_by_css_selector(
        "#graph", timeout=120
    )

    dashjl.wait_for_text_to_equal("#status", "first", timeout=10)

    dashjl.percy_snapshot(name="PlotlyJS figure layout")

    dashjl.find_element("#draw").click()
    dashjl.wait_for_text_to_equal("#status", "second", timeout=10)

    dashjl.percy_snapshot(name="PlotlyJS figure callback")