module WorldFlags
	module Helper
		module View
			module Util
				def self.label_for options = {}
					label = case options[:content]
					when true 
						name
					when String
						options[:content]
					else
						'&nbsp;'
					end
				end				

				def self.title_for name, options = {}
					case options[:title]
					when true
						name
					when String
						options[:title]
					else
						nil
					end				
				end

				def self.flag_options code, title, name, options = {}
					locale = WorldFlags.locale(code)
					extra_options = title ? {:title => title } : {}			
					selected = flag_selected?(code, options) ? ' selected' : ''

					language_name = WorldFlags.language(locale, code)
					country_name = WorldFlags.country(locale, code)

					# add semi class if not selected
					semi = (selected.blank? ? ' semi' : '') if options[:with_semi]

					{:class => "flag #{code}#{selected}#{semi}", :'data-country_name' => country_name, :'data-language_name' => language_name, :'data-cc' => code, :'data-locale' => locale}.merge(options[:html] || {}).merge(extra_options)
				end

				def self.flag_selected? code, options = {}
					code = code.to_sym
					sel = options[:selected] || options[code]

					auto_sel = flag_code(I18n.locale).to_sym if WorldFlags.auto_select?
					match_locales = [sel, auto_sel]

					selected ||= match_locales.any?{|e| e == code }
				end

				# define more mappings by setting WorldFlags.locale_flag_map to a Hash map
				# http://en.wikipedia.org/wiki/ISO_639-1_language_matrix
				def self.flag_code code
					WorldFlags.flag_code code
				end				
			end
		end
	end
end