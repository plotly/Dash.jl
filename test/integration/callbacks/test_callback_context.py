
import pathlib
import os.path
import logging
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_callback_context", filename)

def test_jlcbcx001_modified_response(dashjl):
    fp = jl_test_file_path("jlcbcx001_modified_response.jl") 
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal("#output", "ab - output", timeout=3)
    input1 = dashjl.find_element("#input")

    input1.send_keys("cd")

    dashjl.wait_for_text_to_equal("#output", "abcd - output")
    cookie = dashjl.driver.get_cookie("dash_cookie")
    # cookie gets json encoded
    assert cookie["value"] == 'abcd - cookie'

    assert not dashjl.get_logs()

def test_jlcbcx002_triggered(dashjl):
    fp = jl_test_file_path("jlcbcx002_triggered.jl") 
    dashjl.start_server(fp)
    btns = ["btn-{}".format(x) for x in range(1, 6)]
    dashjl.wait_for_element_by_css_selector("#output", timeout=3)
    for i in range(1, 5):
        for btn in btns:
            dashjl.find_element("#" + btn).click()
            dashjl.wait_for_text_to_equal(
                "#output", "Just clicked {} for the {} time!".format(btn, i)
            )