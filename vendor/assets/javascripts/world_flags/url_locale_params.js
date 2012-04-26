// usage: 

// window.location.href = worldFlagsUrl.addLocaleParameter('da');

// worldFlagsUrl.reloadWithLocaleParam('da');

var worldFlagsUrl = {
	reloadWithLocaleParam: function(locale) {
		window.location.href = worldFlagsUrl.addLocaleParameter(locale);
	},

	addLocaleParameter: function(locale) {
		this.addParameterToURL('locale=' + locale);
	},

	addParameterToURL: function (param) {
	    _url = location.href;
	    _url += (_url.split('?')[1] ? '&':'?') + param;
	    return _url;
	}	
}
