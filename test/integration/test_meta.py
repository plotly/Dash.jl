from selenium.webdriver.support.select import Select
import time, os


app = ''' 
using Dash
using DashHtmlComponents

app = dash("Meta Tags Test", meta_tags = [Dict(["name"=>"description", "content" => "some content"])])

app.layout = html_div(children = "Hello world!", id = "hello-div")

run_server(app)
'''

def test_jltm001_test_meta(dashjl):
    dashjl.start_server(app)
    dashjl.wait_for_text_to_equal(
        "#hello-div",
        "Hello world!"
    )
    assert dashjl.find_element("meta[name='description']").get_attribute("content") == "some content"
    assert dashjl.find_element("meta[charset='UTF-8']")
    assert dashjl.find_element("meta[http-equiv='X-UA-Compatible']").get_attribute("content") == "IE=edge"


app2 = ''' 
using Dash
using DashHtmlComponents

app = dash("Meta Tags Test", meta_tags = [Dict(["charset"=>"ISO-8859-1", "keywords"=>"dash,pleasant,productive", "http-equiv"=>"content-type", "content"=>"text/html"])])

app.layout = html_div(children = "Hello world!", id = "hello-div")

run_server(app)
'''


def test_jltm002_test_meta(dashjl):
    dashjl.start_server(app2)
    dashjl.wait_for_text_to_equal(
        "#hello-div",
        "Hello world!"
    )
    assert dashjl.find_element("meta[charset='ISO-8859-1']")
    assert dashjl.find_element("meta[keywords='dash,pleasant,productive']").get_attribute("keywords") == "dash,pleasant,productive"
    assert dashjl.find_element("meta[http-equiv='content-type']").get_attribute("content") == "text/html"
