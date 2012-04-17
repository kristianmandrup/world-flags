require 'json'

content = File.open('country_codes_table.html').read #_lines[0..20].join

# content = %q{
# <table class="wikitable sortable">
# <tr>
# <th>Code</th>
# <th>Country name</th>
# <th>Year</th>
# <th>ccTLD</th>
# <th><span class="nowrap">ISO 3166-2</span></th>
# <th class="unsortable">Notes</th>
# </tr>
# <tr>
# <td id="AD"><tt>AD</tt></td>
# <td><a href="/wiki/Andorra" title="Andorra">Andorra</a></td>
# <td>1974</td>
# <td><a href="/wiki/.ad" title=".ad">.ad</a></td>
# <td><span class="nowrap"><a href="/wiki/ISO_3166-2:AD" title="ISO 3166-2:AD">ISO 3166-2:AD</a></span></td>
# <td></td>
# </tr>
# <tr>
# <td id="AE"><tt>AE</tt></td>
# <td><a href="/wiki/United_Arab_Emirates" title="United Arab Emirates">United Arab Emirates</a></td>
# <td>1974</td>
# <td><a href="/wiki/.ae" title=".ae">.ae</a></td>
# <td><span class="nowrap"><a href="/wiki/ISO_3166-2:AE" title="ISO 3166-2:AE">ISO 3166-2:AE</a></span></td>
# <td></td>
# </tr>
# <tr>
# <td id="AF"><tt>AF</tt></td>
# <td><a href="/wiki/Afghanistan" title="Afghanistan">Afghanistan</a></td>
# <td>1974</td>
# <td><a href="/wiki/.af" title=".af">.af</a></td>
# <td><span class="nowrap"><a href="/wiki/ISO_3166-2:AF" title="ISO 3166-2:AF">ISO 3166-2:AF</a></span></td>
# <td></td>
# </tr>
# <tr>	
# }

codes = content.scan(/tt>(\w+)<\/tt/m)

names = content.scan(/title="([\w|\s|\'|\-|\,]+)"/m)

zipped = codes.zip(names)

hash = {}
zipped.each do |pair|
	pair = pair.flatten
	hash[pair.first.to_s.downcase] = pair.last
end

json = JSON.pretty_generate(hash)

File.open('ISO-3166-2_codes.en.json', 'w+') do |f|
	f.puts json
end

