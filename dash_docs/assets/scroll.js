window.pageMenuScroll = function pageMenuScroll(id) {
    var el = document.getElementById(id);
    if(el && el.scrollIntoView) {
        el.scrollIntoView();
    }
}
