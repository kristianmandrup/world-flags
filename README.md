# Country or language selection with Flag icons

This gem can be used with Rails 3. It includes css files for size 16 and 32 pixels and have all the worlds' flags. See http://spritegen.website-performance.org/

## Configuration

In you asset `application.css` manifest file:

```css
*/
 *= require_self
 *= require_tree .
 *= require flags/basic
 *= require flags/flags32
 *= require flags/flags32_semi
*/
```

The `flags/basic` stylesheet sets up a basic css for use with borders around the 32 and 64 pixel flag images (to mark selected language). Use this css as inspiration and customize by overriding styles as needed.

There is also support for semi-transparent flags. This can be used to fade certain flags while having the selected flag (or hovered over flag) in full brightness.

Simply add or remove the "semi" class for the flag to adjust the brightness level (fx for selection/mouse over).

```javascript
$("li.flag['data-cc'=dk).addClass('semi');
$("li.flag['data-cc'=dk).removeClass('semi');
```

```css
*/
 *= require_self
 *= require_tree .
 *= require flags/flags32
 *= require flags/flags62
*/
```

## Alternative config

Note that the ruby examples uses HAML syntax

In the head of your view or layout file:

```haml
= stylesheet_link_tag 'flags16'
```

or using a helper

```haml
= use_flags(16)
```

Alternatively for the 32 width flags

```haml
= use_flags 32
```

## Configuring localization

You can setup WorldFlags to use a localization map for the labels of the flag icons

WorldFlags.languages = some_language_hash # fx loaded from a yaml file
WorldFlags.countries = some_country_hash # fx loaded from a yaml file

Notice that it is a locale code pointing to a map of ISO_3166-1_alpha-2 codes 
to labels for that locale.

```ruby
{
	:en => {:gb => 'English', :dk => 'Danish'}
	:da => {:gb => 'Engelsk', :dk => 'Dansk'}
}
```

An english translation file of country codes (in json format) can be found in app/config/country_codes.

```ruby
cc_file_en = File.join(Rails.root, 'app/config/country_codes/iso-3166-2.en.json')
country_codes_en = JSON.parse File.read(cc_file_en)
WorldFlags.languages = country_codes_en
```

Here an even better, more flexible approach that allows for multiple translations.

```
WorldFlags::Language.en = country_codes_en
```

If you use this approach, you must currently add a WorldFlags::Language class method for that locale (fx a method `#da`for danish) or fx use `attr_accessor :da`. For this approach, you must also set the active locales using `#active_locales`.

```
WorldFlags.active_locales = [:en, :da]
WorldFlags::Language.da = country_codes_da
```

Please feel free to suggest or improve this locale/translation infrastructure!

## Rendering

Flags will be rendered in HTML as:

```html
<pre>
<ul class="f32">
  <li class="flag ar" data-cc="ar" data-country="Argentina">Argentina</li>
  <li class="flag gb" data-cc="gb" data-country="England">England</li>
...
</ul>
</pre>
```

The countries corresponding to the codes can be found at "http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2":http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

## Use

WorldFlags supports flag sizes in 16, 32 and 64 pixels (size).

You can also use built in helper methods:

```haml
= flag_list 16 do
	= flags [:ar, :gb], :selected => :gb
```

Alternatively

```haml
= flag_list 32 do
	= flag(:ar)
	= flag(:gb, :selected => true)
```

Or using the #flag_code helper

```haml
	= flag(:ar) + flag(:gb, :selected => flag_code(I18n.locale)
```

For use with tooltips or similar js plguins, it can be useful to set the <li> title attribute:

```haml
= flag_list 32 do
	= flags [:ar, :br, :gb], :title => true
```

The flag_title will render the following list item:

```html
<li class="flag ar" lang="ar" title="Argentina">&nbsp;</li>
```

Note: The `&nbsp; is needed in order for the background (flag icon) to have something to be displayed against.

The :title and :content can also be set to a string which is then displayed

```haml
= flag :ar, :title => 'Argentina is the best', :content => 'Argh!'
```

To also get content rendered for the <li>

```haml
	= flags [:ar, :br, :gb], :content => true
```

Note: There is also a #flag_selected? helper, which is (and/or can be) used to determine if the flag to be drawn should have the "selected" class set)
The auto-select feature is by default turned off, but can be turned on/off using:

```ruby
WorldFlags.auto_select = true # or WorldFlags.auto_select!
```

## Using localization

You can specify whether to look up labels for the flags for either language or country and for which locale to look up the labels (see Configuring localization)

Use danish (da) country labels

```haml
= flag_list 32 do
	= flags [:ar, :br, :gb], :country => :da
```

Use danish (da) language labels

```haml
= flag_list 32 do
	= flags [:ar, :br, :gb], :language => I18n.locale
```

Note: In the config folder there is now a json file with all the english ISO-3166-2 code translations ready for use. You can make similar locale files for other locales/languages.

h## Get client country code (browser and geo)

A small helper module is provided that can be inserted into a Controller or wherever you see fit

* ip_country_code
* browser_locale

```ruby
class MainController < ApplicationController
  def home
  	@json = Property.all.to_gmaps4rails
    @country_code = WorldFlags::Geo.ip_country_code
  end
end
```

Alternatively you can include the modules directly into the controller:

```ruby
class MainController < ApplicationController
	include WorldFlags::Geo
	include WorldFlags::Browser

  def home
  	@json = Property.all.to_gmaps4rails
    @country_code = ip_country_code
    @locale = browser_locale
  end
end
```

If you include the `WorldFlags::Locale` module, you can simply do:

```ruby
before_filter :set_locale
```

And it should set the I18n.locale appropriately, trying `params[locale], browser, ip address` in succession, defaulting to `I18n.default_locale`.

For each locale it will check if it is a valid locale. By default it will call `valid_locales` in the controller, which will first try `I18n.available_locales` and then fall-back to `WorldFlags::Locale#valid_locales`.
You can override this behavior by defining you custom `valid_locales` method in the controller.

For convenience you can include `WorldFlags::All` to include all these helper modules.

Example:

```ruby
class MainController < ApplicationController
	include WorldFlags::All

	before_filter :set_locale	
end
```

You can configure valid locales for use with WorldFlags in an initializer, fx `initializers/locales.rb` :

```ruby
# fx [:da, :en] or even ['da', 'en']
WorldFlags::Locale.valid_locales = my_valid_locales_list 
```

Note that if not set, this list is preconfigured to: `['en', 'de', 'es', 'ru']`

Alternatively configure in your `application.rb` file:

```ruby
class Application < Rails::Application
  # ...
  config.i18n.available_locales = [:da, :sv, :no]
``

Note: This approach in turn works well with the `i18n-docs` gem ;)

## Post flag selection

Here an example of setting up a flag click handler in order to call the server with the country/locale/language selection of the flag.

```javascript
$("li.flag").click(function() {
	country = $(this).data('locale');

	// full page reload
	// window.location.href = "/locale/select/" + country;

	// window.location.href = window.location.href + '?locale=' + country;

	// async post
	$.post("/locale/select", { "country": country }, function(data) {
		console.log(data);
	});	
});
```

This gem now comes with a simple javascript object baked in:

```
//= require world_flags/url_locale_params
```

```javascript
$("li.flag").click(function() {
	country = $(this).data('locale');

	// full page reload with locale=xx param added to url :)
	worldFlagsUrl.reloadWithLocaleParam('da');
});
```

## Enjoy

Copyright (2012) Kristian Mandrup

