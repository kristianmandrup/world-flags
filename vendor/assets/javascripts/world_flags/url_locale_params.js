// Usage: 
// worldFlagsUrl.reloadWithLocaleParam('da');

var worldFlagsUrl = {
  reloadWithLocaleParam: function(locale) {
    this.addLocaleParameter(window.location.href, locale);
    window.reload();
  },

  addLocaleParameter: function(url, locale) {
    this.addParameterToURL(url, 'locale', locale);
  },

  addParameterToURL: function(_url, _key, _value){
    var param = _key+'='+escape(_value);

    var sep = '&';
    if (_url.indexOf('?') < 0) {
      sep = '?';
    } else {
      var lastChar=_url.slice(-1);
      if (lastChar == '&') sep='';
      if (lastChar == '?') sep='';
    }
    _url += sep + param;

    return _url;
  }
}