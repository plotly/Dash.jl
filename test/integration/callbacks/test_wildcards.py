import pathlib
import os.path
import logging
import pytest
import re
from selenium.webdriver.common.keys import Keys
logger = logging.getLogger(__name__)

curr_path = pathlib.Path(__file__).parent.absolute()
def jl_test_file_path(filename):
    return os.path.join(curr_path, "jl_test_wildcards", filename)

def css_escape(s):
    sel = re.sub("[\\{\\}\\\"\\'.:,]", lambda m: "\\" + m.group(0), s)
    print(sel)
    return sel

@pytest.mark.parametrize("content_callback", (False, True))
def test_jlcbwc001_todo_app(content_callback, dashjl):
    jl_file = "jlcbwc001_todo_app_true.jl" if content_callback else "jlcbwc001_todo_app_false.jl"
    fp = jl_test_file_path(jl_file)
    dashjl.start_server(fp)
    dashjl.wait_for_text_to_equal("#totals", "0 of 0 items completed", timeout = 10)

    new_item = dashjl.find_element("#new-item")
    add_item = dashjl.find_element("#add")
    clear_done = dashjl.find_element("#clear-done")

    def assert_count(items):
        assert len(dashjl.find_elements("#list-container>div")) == items

    def get_done_item(item):
        selector = css_escape('#{"action":"done","item":%d} input' % item)
        return dashjl.find_element(selector)

    def assert_item(item, text, done, prefix="", suffix=""):
        dashjl.wait_for_text_to_equal(css_escape('#{"item":%d}' % item), text, timeout=10)

        expected_note = "" if done else (prefix + " preceding items are done" + suffix)
        dashjl.wait_for_text_to_equal(
            css_escape('#{"item":%d,"preceding":true}' % item), expected_note
        )

        assert bool(get_done_item(item).get_attribute("checked")) == done

    new_item.send_keys("apples")
    add_item.click()
    dashjl.wait_for_text_to_equal("#totals", "0 of 1 items completed - 0%", timeout = 10)
    assert_count(1)

    new_item.send_keys("bananas")
    add_item.click()
    dashjl.wait_for_text_to_equal("#totals", "0 of 2 items completed - 0%", timeout = 10)
    assert_count(2)

    new_item.send_keys("carrots")
    add_item.click()
    dashjl.wait_for_text_to_equal("#totals", "0 of 3 items completed - 0%", timeout = 10)
    assert_count(3)

    new_item.send_keys("dates")
    add_item.click()
    dashjl.wait_for_text_to_equal("#totals", "0 of 4 items completed - 0%", timeout = 10)
    assert_count(4)
    assert_item(1, "apples", False, "0 of 0", " DO THIS NEXT!")
    assert_item(2, "bananas", False, "0 of 1")
    assert_item(3, "carrots", False, "0 of 2")
    assert_item(4, "dates", False, "0 of 3")

    get_done_item(3).click()
    dashjl.wait_for_text_to_equal("#totals", "1 of 4 items completed - 25%", timeout = 10)
    assert_item(1, "apples", False, "0 of 0", " DO THIS NEXT!")
    assert_item(2, "bananas", False, "0 of 1")
    assert_item(3, "carrots", True)
    assert_item(4, "dates", False, "1 of 3")

    get_done_item(1).click()
    dashjl.wait_for_text_to_equal("#totals", "2 of 4 items completed - 50%", timeout = 10)
    assert_item(1, "apples", True)
    assert_item(2, "bananas", False, "1 of 1", " DO THIS NEXT!")
    assert_item(3, "carrots", True)
    assert_item(4, "dates", False, "2 of 3")

    clear_done.click()
    dashjl.wait_for_text_to_equal("#totals", "0 of 2 items completed - 0%", timeout = 10)
    assert_count(2)
    assert_item(1, "bananas", False, "0 of 0", " DO THIS NEXT!")
    assert_item(2, "dates", False, "0 of 1")

    get_done_item(1).click()
    dashjl.wait_for_text_to_equal("#totals", "1 of 2 items completed - 50%", timeout = 10)
    assert_item(1, "bananas", True)
    assert_item(2, "dates", False, "1 of 1", " DO THIS NEXT!")

    get_done_item(2).click()
    dashjl.wait_for_text_to_equal("#totals", "2 of 2 items completed - 100%", timeout = 10)
    assert_item(1, "bananas", True)
    assert_item(2, "dates", True)

    clear_done.click()
    # This was a tricky one - trigger based on deleted components
    dashjl.wait_for_text_to_equal("#totals", "0 of 0 items completed")
    assert_count(0)

@pytest.mark.parametrize("clientside", (False, True))
def test_jlcbwc002_fibonacci_app(clientside, dashjl):
    jl_file = "jlcbwc002_fibonacci_app_true.jl" if clientside else "jlcbwc002_fibonacci_app_false.jl"
    fp = jl_test_file_path(jl_file)
    dashjl.start_server(fp)

    # app starts with 4 elements: 0, 1, 1, 2
    dashjl.wait_for_text_to_equal("#sum", "4 elements, sum: 4", timeout = 10)

    # add 5th item, "3"
    dashjl.find_element("#n").send_keys(Keys.UP)
    dashjl.wait_for_text_to_equal("#sum", "5 elements, sum: 7", timeout = 10)

    # add 6th item, "5"
    dashjl.find_element("#n").send_keys(Keys.UP)
    dashjl.wait_for_text_to_equal("#sum", "6 elements, sum: 12", timeout = 10)

    # add 7th item, "8"
    dashjl.find_element("#n").send_keys(Keys.UP)
    dashjl.wait_for_text_to_equal("#sum", "7 elements, sum: 20", timeout = 10)

    # back down all the way to no elements
    dashjl.find_element("#n").send_keys(Keys.DOWN)
    dashjl.wait_for_text_to_equal("#sum", "6 elements, sum: 12", timeout = 10)
    dashjl.find_element("#n").send_keys(Keys.DOWN)
    dashjl.wait_for_text_to_equal("#sum", "5 elements, sum: 7", timeout = 10)
    dashjl.find_element("#n").send_keys(Keys.DOWN)
    dashjl.wait_for_text_to_equal("#sum", "4 elements, sum: 4", timeout = 10)
    dashjl.find_element("#n").send_keys(Keys.DOWN)
    dashjl.wait_for_text_to_equal("#sum", "3 elements, sum: 2", timeout = 10)
    dashjl.find_element("#n").send_keys(Keys.DOWN)
    dashjl.wait_for_text_to_equal("#sum", "2 elements, sum: 1", timeout = 10)
    dashjl.find_element("#n").send_keys(Keys.DOWN)
    dashjl.wait_for_text_to_equal("#sum", "1 elements, sum: 0", timeout = 10)
    dashjl.find_element("#n").send_keys(Keys.DOWN)
    dashjl.wait_for_text_to_equal("#sum", "0 elements, sum: 0", timeout = 10)

def test_jlcbwc003_same_keys(dashjl):
    fp = jl_test_file_path("jlcbwc003_same_keys.jl")
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal("#add-filter", "Add Filter", timeout = 10)
    dashjl.select_dcc_dropdown(
        '#\\{\\"index\\"\\:0\\,\\"type\\"\\:\\"dropdown\\"\\}', "LA"
    )
    dashjl.wait_for_text_to_equal(
        '#\\{\\"index\\"\\:0\\,\\"type\\"\\:\\"output\\"\\}', "Dropdown 0 = LA", timeout = 10
    )
    dashjl.find_element("#add-filter").click()
    dashjl.select_dcc_dropdown(
        '#\\{\\"index\\"\\:1\\,\\"type\\"\\:\\"dropdown\\"\\}', "MTL"
    )
    dashjl.wait_for_text_to_equal(
        '#\\{\\"index\\"\\:1\\,\\"type\\"\\:\\"output\\"\\}', "Dropdown 1 = MTL", timeout = 10
    )
    dashjl.wait_for_text_to_equal(
        '#\\{\\"index\\"\\:0\\,\\"type\\"\\:\\"output\\"\\}', "Dropdown 0 = LA", timeout = 10
    )
    dashjl.wait_for_no_elements(dashjl.devtools_error_count_locator)

def test_jlcbwc004_layout_chunk_changed_props(dashjl):
    fp = jl_test_file_path("jlcbwc004_layout_chunk_changed_props.jl")
    dashjl.start_server(fp)

    dashjl.wait_for_text_to_equal("#container", "No content initially", timeout = 10)
    dashjl.wait_for_text_to_equal(
        "#output-outer", "triggered is Falsy with prop_ids", timeout = 10
    )

    dashjl.find_element("#btn").click()
    dashjl.wait_for_text_to_equal(
        "#output-outer",
        'triggered is Truthy with prop_ids {"index":2,"type":"input"}.value', timeout = 10
    )
    dashjl.wait_for_text_to_equal(
        "#output-inner", "triggered is Falsy with prop_ids", timeout = 10
    )

    dashjl.find_elements("input")[0].send_keys("X")
    trigger_text = 'triggered is Truthy with prop_ids {"index":1,"type":"input"}.value'
    dashjl.wait_for_text_to_equal("#output-outer", trigger_text, timeout = 10)
    dashjl.wait_for_text_to_equal("#output-inner", trigger_text, timeout = 10)

