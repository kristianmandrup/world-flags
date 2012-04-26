module WorldFlags
	module Helper
		module View
			def self.flag_sizes
				[16, 32, 64]
			end

			# define more mappings by setting WorldFlags.locale_flag_map to a Hash map
			# http://en.wikipedia.org/wiki/ISO_639-1_language_matrix
			def flag_code code
				WorldFlags.flag_code code
			end

			def flags_list size = 16, &block
				raise "Missing block" unless block_given?
				raise "Supported sizes are only #{WorldFlags::ViewHelper.flag_sizes}" unless WorldFlags::ViewHelper.flag_sizes.include?(size.to_i)
				content = capture(&block)
				content_tag :ul, content, :class => "f#{size}"
			end
			alias_method :flag_list, :flags_list

			# http://en.wikipedia.org/wiki/ISO_639-1_language_matrix

			# should look up translation for each code
			def flags flags_arr, options = {}
				flags_arr.inject("") do |res, elem|
					case elem
					when Array
						code = elem.first
						name = elem.last
					when String, Symbol
						code = elem
						name = WorldFlags.label(code, options)
					else
						raise ArgumentError, "Bad argument: #{flags_arr}, must be Hash or Array"
					end				
					res << flag(code, name, options)
				end.html_safe
			end

			def flags_title flags_arr, options = {}
				flags flags_arr, options.merge(:title => true)
			end

			def flag code, name, options = {}
				label = case options[:content]
				when true 
					name
				when String
					options[:content]
				else
					'&nbsp;'
				end

				title = case options[:title]
				when true
					name
				when String
					options[:title]
				else
					nil
				end
				locale = WorldFlags.locale(code)
				extra_options = title ? {:title => title } : {}			
				selected = flag_selected?(code, options) ? 'selected' : ''
				content_tag :li,  label.html_safe, {:class => "flag #{code} #{selected}", :'data-country' => name, :'data-cc' => code, :'data-locale' => locale}.merge(options[:html] || {}).merge(extra_options)
			end

			def flag_selected? code, options = {}
				selected = options[:selected] || options[code.to_sym]
				selected ||= (flag_code(I18n.locale.to_sym) == code.to_sym) if WorldFlags.auto_select?
			end

			def flag_title code, name, options = {}
				flag code, name, options.merge(:title => true)
			end

			def use_flags size = 16
				stylesheet_link_tag "flags/flags#{size}"
			end
		end
	end
end