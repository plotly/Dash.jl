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


app = ''' 
using Dash
using DashHtmlComponents
using DashCoreComponents

app = dash("Undo/Redo Test App", show_undo_redo=true)

app.layout = html_div() do
 dcc_input(id="a"),
 html_div(id="b") 
end

callback!(app, CallbackId(
    input = [(:a, :value)],
    output = [(:b, :children)]
    )
    ) do inputValue
    return inputValue
end

run_server(app)
'''


def test_jltr001r_undo_redo(dashjl):
    dashjl.start_server(app)
    dashjl.wait_for_element_by_css_selector(
        "#a"
    )   
    input1 = dashjl.find_element("#a")
    input1.send_keys("xyz")
    dashjl.wait_for_text_to_equal(
        "#b", "xyz", timeout=1
    )
    click_undo(dashjl)
    dashjl.wait_for_text_to_equal(
        "#b", "xy", timeout=1
    )
    click_undo(dashjl)
    dashjl.wait_for_text_to_equal(
        "#b", "x", timeout=1
    )
    click_redo(dashjl)
    dashjl.wait_for_text_to_equal(
        "#b", "xy", timeout=1
    )
    dashjl.percy_snapshot(name="undo-redo")
    click_undo(dashjl)
    click_undo(dashjl)
    dashjl.wait_for_text_to_equal(
        "#b", "", timeout=1
    )
