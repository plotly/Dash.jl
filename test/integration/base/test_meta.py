from selenium.webdriver.support.select import Select
import time, os
import pathlib
import os.path

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_test_meta", filename)

def test_jltm001_test_meta(dashjl):
    fp = jl_test_file_path("jltm001_test_meta.jl") 
    dashjl.start_server(fp)
    dashjl.wait_for_text_to_equal(
        "#hello-div",
        "Hello world!"
    )
    assert dashjl.find_element("meta[name='description']").get_attribute("content") == "some content"
    assert dashjl.find_element("meta[charset='UTF-8']")
    assert dashjl.find_element("meta[http-equiv='X-UA-Compatible']").get_attribute("content") == "IE=edge"


def test_jltm002_test_meta(dashjl):
    fp = jl_test_file_path("jltm002_test_meta.jl") 
    dashjl.start_server(fp)
    dashjl.wait_for_text_to_equal(
        "#hello-div",
        "Hello world!"
    )
    assert dashjl.find_element("meta[charset='ISO-8859-1']")
    assert dashjl.find_element("meta[keywords='dash,pleasant,productive']").get_attribute("keywords") == "dash,pleasant,productive"
    assert dashjl.find_element("meta[http-equiv='content-type']").get_attribute("content") == "text/html"
