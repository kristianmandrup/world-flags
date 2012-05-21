# World Flags

This engine/gem can be used with Rails 3+. WorldFlags includes css files for flags of the following pixel sizes:
* 16 
* 32
* 64 

The sprites contains all the main country flags in the world.

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

The `flags/basic` stylesheet sets up a basic css for use with borders around the flag images (to mark selected language). Use this css as inspiration and customize by overriding styles as needed.

There is also support for semi-transparent flags. This can be used to fade certain flags while having the selected flag (or hovered over flag) in full brightness.

Simply add or remove the "semi" class for the flag to adjust the brightness level (fx for selection/mouse over).

## Rendering

Flags will be rendered in HTML as:

```html
<pre>
  <ul class="f32">
  	<li class="flag ar selected" data-cc="ar" data-country_name="Argentina" data-language_name="Spanish" data-locale="ar">&nbsp;</li>
...
</ul>
</pre>
```

The countries corresponding to the codes can be found at [ISO 3166-1 alpha-2](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)

## Use

WorldFlags supports flag sizes in 16, 32 and 64 pixels (size).

You can also use built in helper methods:

```haml
= flag_list 16 do
	= flags :ar, :gb, :selected => :gb
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

You can also include the :with_semi => true option in order to have flags not selected displayed with the 'semi' class (semi-bright image)

For use with tooltips or similar js plguins, it can be useful to set the <li> title attribute:

```haml
= flag_list 32 do
	= flags :ar, :br, :gb, :title => true
```

The flag_title will render the following list item:

```html
<li class="flag ar" lang="ar" title="Argentina">&nbsp;</li>
```

Note: The `&nbsp; is needed in order for the background (flag icon) to have something to be displayed against.

The :title and :content can also be set to a string which is then displayed

```haml
= flag :ar, :title => 'Argentina country', :content => 'Argh!'
```

To get content rendered for the <li>

```haml
	= flags :ar, :br, :gb, :content => true
```

Note: There is also a #flag_selected? helper, which is (and/or can be) used to determine if the flag to be drawn should have the "selected" class set)

## Using localization

You can specify whether to look up labels for the flags for either language or country and for which locale to look up the labels (see Configuring localization)

Use danish (da) country labels

```haml
= flag_list 32 do
	= flags :ar, :br, :gb, :country => :da
```

Use language labels for current locale

```haml
= flag_list 32 do
	= flags :ar, :br, :gb, :language => I18n.locale
```

In the /config folder of this gem/engine there is a json file with all the english _ISO-3166-2_ code translations ready for use. You can make similar locale files for other locales/languages. You can use either of the following:

* [countries_and_languages](https://github.com/grosser/countries_and_languages)
* [i18n data](https://github.com/grosser/i18n_data)
* [i18n gen](https://github.com/kristianmandrup/i18n-gen)

To generate i18n data for your particular locale(s).

## Configuration and usage tips

See the [wiki](https://github.com/kristianmandrup/world-flags/wiki/)

* [Configuration](https://github.com/kristianmandrup/world-flags/wiki/Configuration)
* [Handling flag selection](https://github.com/kristianmandrup/world-flags/wiki/Handling-flag-selection)

## Geo IP

Include the 'geoip' gem if you want to detect locale based on browser IP location.

[GeoIP country lite](http://www.maxmind.com/app/geolitecountry)
[GeoIP](http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz)

Extract and put latest `GeoIP.dat` file in `db/GeoIP.dat` of your Rails app. Alternatively set location via `WorldFlags.geo_ip_db_path = path`. 

The _world-flags_ engine comes pre-packaged with a recent version of `GeoIP.dat` in the `db` folder of the engine itself.

### GeoIP generator

Copy WorldFlags GeoIP.dat to Rails app '/db/GeoIP.dat'

TODO: Should optimally fetch the one from maxmind.com

`rails g world_flags:geoip`

### Localhosts filtering

Also set `WorldFlags.localhost_list` if you have localhosts other than the default `127.0.0.1`.

You can override the default ip passed to the `Geo module by overriding the `browser_ip` method in your controller. Here the default implementation is shown:

### Fine control of the IP used

```ruby
def browser_ip
  request.remote_ip
end
```

Code extract of the locale source logic for browser IP country code detection:

```ruby
when :ip
  country_code_from_ip browser_ip
```

## TODO for version 1.0

Suggestions welcome ;)

## Enjoy

Copyright (2012) Kristian Mandrup

