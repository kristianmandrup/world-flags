// Usage: 
// WorldFlagsUrlHelper.reloadWithLocaleParam('da');

var WorldFlagsUrlHelper = {
  reloadWithLocaleParam: function(locale) {

    // will reload page with 'locale' param added for locale
    // fx www.example.com?locale=da
    // or www.example.com?status=ok&locale=da
    window.location.href = this.addLocaleParameter(window.location.href, locale);     
  },

  addLocaleParameter: function(url, locale) {
    //return this.addParameterToURL(url, 'locale', locale);
    return this.addUrlParameter(url, 'locale', locale, true);    
  },

  // From http://stackoverflow.com/questions/486896/adding-a-parameter-to-the-url-with-javascript
  addUrlParameter: function (sourceUrl, parameterName, parameterValue, replaceDuplicates) {
    if ((sourceUrl == null) || (sourceUrl.length == 0)) sourceUrl = document.location.href;
    var urlParts = sourceUrl.split("?");
    var newQueryString = "";
    if (urlParts.length > 1)
    {
        var parameters = urlParts[1].split("&");
        for (var i=0; (i < parameters.length); i++)
        {
                var parameterParts = parameters[i].split("=");
                if (!(replaceDuplicates && parameterParts[0] == parameterName))
                {
                        if (newQueryString == "")
                                newQueryString = "?";
                        else
                                newQueryString += "&";
                        newQueryString += parameterParts[0] + "=" + parameterParts[1];
                }
        }
    }
    if (newQueryString == "")
        newQueryString = "?";
    else
        newQueryString += "&";

    newQueryString += parameterName + "=" + parameterValue;

    return urlParts[0] + newQueryString;
  }
}