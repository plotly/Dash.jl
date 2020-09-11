import pathlib
import os.path
import logging
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_render", filename)

def click_undo(self):
    undo_selector = "._dash-undo-redo span:first-child div:last-child"
    undo = self.wait_for_element_by_css_selector(undo_selector)
    self.wait_for_text_to_equal(undo_selector, "undo")
    undo.click()


def click_redo(self):
    redo_selector = "._dash-undo-redo span:last-child div:last-child"
    self.wait_for_text_to_equal(redo_selector, "redo")
    redo = self.wait_for_element_by_css_selector(redo_selector)
    redo.click()



def test_jltr001r_undo_redo(dashjl):
    fp = jl_test_file_path("jltr001r_undo_redo.jl")
    dashjl.start_server(fp)
    dashjl.wait_for_element_by_css_selector(
        "#a", timeout=4
    )
    input1 = dashjl.find_element("#a")
    input1.send_keys("xyz")
    dashjl.wait_for_text_to_equal(
        "#b", "xyz", timeout=4
    )
    click_undo(dashjl)
    dashjl.wait_for_text_to_equal(
        "#b", "xy", timeout=2
    )
    click_undo(dashjl)
    dashjl.wait_for_text_to_equal(
        "#b", "x", timeout=2
    )
    click_redo(dashjl)
    dashjl.wait_for_text_to_equal(
        "#b", "xy", timeout=2
    )
    dashjl.percy_snapshot(name="undo-redo")
    click_undo(dashjl)
    click_undo(dashjl)
    dashjl.wait_for_text_to_equal(
        "#b", "", timeout=2
    )
