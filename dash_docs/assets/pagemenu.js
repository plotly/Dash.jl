window.dash_clientside = Object.assign({}, window.dash_clientside, {
  clientside: {
    pagemenu: function (children) {
      return String(Date.now());
    }
  }
});
