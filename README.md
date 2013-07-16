# World Flags

This engine/gem can be used with Rails 3+. WorldFlags includes css files for flags of the following pixel sizes:

* 16
* 24 
* 32
* 48
* 64 

The sprites contains all the main country flags in the world.

You can use the [sprite generator](http://spritegen.website-performance.org/) to generate sprites for other icons sets and follow the pattern for this gem.

You can also see the [pictos-icons](https://github.com/kristianmandrup/pictos-icons)  
or [social_icons](https://github.com/kristianmandrup/social_icons) gems for other examples using this model.

Also check out the [world-flag-packs](https://github.com/kristianmandrup/world-flag-packs) repo, that contains multiple flag packs ready for use with `world-flags.

## Customizing Flag sprite size

*Resize images:*

Use ImageMagick to resize, using 32px version as base

`convert flags32.png -resize 75% flags24.png`

`convert flags32_semi.png -resize 75% flags24_semi.png`

*Generate adsjusted css files:*

The CSS files must have positioning adjusted to fit the new sprites:
Use the resizing tool in `lib/world-flags/tools/resize_css.rb`
Edit the last part where ResizeCss is initialized

`resizer = ResizeCss.new 32, 24`

The last argument (here 24) is the flag size used for calculating new positioning in the css files generated.

The ResizeCSS initializer takes many additional options, including :auto-exec to auto convert the sprite using ImageMagick.

`resizer = ResizeCss.new 32, 24, auto-exec: true`

See the code for more details on how to adjust to fit your needs.

Run the resizer

`$ ruby resize_css.rb`

TODO: refactor resize css tool into rake task or similar that takes arguments!

## Configuration

In your asset `application.css` manifest file:

```css
/*
 *= require_self
 *= require_tree .
 *= require flags/basic
 *= require flags/flags16
 *= require flags/flags32
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

WorldFlags supports flag sizes in 16, 24, 32, 48 and 64 pixels (size).

You can also use built in helper methods:

```haml
= flag_list 16 do
	= flags :ar, :gb, :selected => :gb
```

Alternatively

```haml
= flag_list 32 do
	= flag(:ar, 'Argentina')
	= flag(:gb, 'England', :selected => true)
```

Or using the locale mappings for the label...

```haml
= flag_list 32 do
  = flag(:ar)
  = flag(:gb, :selected => true)
```

Or using the #flag_code helper

```haml
	= flag(:ar, 'Argentina') + flag(:gb, 'England', :selected => flag_code(I18n.locale)
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
= flag :ar, 'Argentina', :title => 'Argentina country', :content => 'Argh!'
```

or using the locale mapping...

```haml
= flag :ar, :title => 'Argentina country'
```

To get content rendered for the <li>

```haml
	= flags :ar, :br, :gb, :content => true
```

Note: There is also a #flag_selected? helper, which is (and/or can be) used to determine if the flag to be drawn should have the "selected" class set)

## Configuration

To disable use of country- and language name data attributes in output:

```ruby
WorldFlags.country_name_disable!
WorldFlags.language_name_disable!
```

## Customizing output

You can customize the output by the flag view helper methods:

```ruby
WorldFlags.flag_list_tag = :div
WorldFlags.flag_tag = :span
WorldFlags.flag_text = ''
```

To do more customization, look at the `world_flags/helper/view/util.rb` file.

## Using localization

You can specify whether to look up labels for the flags for either language or country and for which locale to look up the labels (see Configuring localization)

Use danish (da) country labels

```haml
= flag_list 32 do
	= flags :ar, :br, :gb, :country => :da
```

Use language labels for current locale.
Note: Also use border class (see CSS below)

```haml
= flag_list 32, :class => 'border' do
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

## CSS

The `basic.css` file in the `vendor/assets/stylesheets/flags` folder of this repo defines the basic styling of flags. Override these styles to fit your needs.

```ruby
.flags {
  list-style-type: none;
  padding: 0;
  margin-left: 0;  
}

.flags .l {
  float: left;
}

.border .flag {
  border: 1px solid;  
}

.border .selected {
  border: 1px solid black;
}

.f16.flag {
  width: 16px;
  height: 16px;
}

.f24.flag {
  width: 24px;
  height: 24px;
}

 /* and so on ... */
```

## TODO for version 1.0

Suggestions welcome ;)

## Enjoy

Copyright (2012) Kristian Mandrup

