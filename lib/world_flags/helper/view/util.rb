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
						WorldFlags.flag_text
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
					locale = I18n.locale
					extra_options = title ? {:title => title } : {}			
					selected = flag_selected?(code, options) ? ' selected' : ''

					# add semi class if not selected
					semi = (selected.blank? ? ' semi' : '') if options[:with_semi]
					xclass = options[:class] ? " #{options[:class]}" : ''

					if WorldFlags.country_name_enabled?
						country_name = WorldFlags.country(code, locale)						
					end
					country_option = country_name ? {:'data-country_name' => country_name} : {}

					if WorldFlags.language_name_enabled?
						language_name = WorldFlags.language(code, locale)
					end
					language_option = language_name ? {:'data-language_name' => language_name} : {}

					flag_locale = WorldFlags.locale(code)

					{:class => "flag #{code}#{selected}#{semi}#{xclass}", :'data-cc' => code, :'data-locale' => flag_locale}.merge(options[:html] || {}).merge(extra_options).merge(country_option).merge(language_option)
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