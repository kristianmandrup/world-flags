module WorldFlags
	module ViewHelper
		def self.flag_sizes
			[16, 32, 64]
		end

		def flags_list size = 16, &block
			raise "Missing block" unless block_given?
			raise "Supported sizes are only #{WorldFlags::ViewHelper.flag_sizes}" unless WorldFlags::ViewHelper.flag_sizes.include?(size.to_i)
			content = capture(&block)
			content_tag :ul, content, :class => "f#{size}"
		end
		alias_method :flag_list, :flags_list

		def flags flags_hash, display = false
			flags_hash.inject("") do |res, element|
				res << flag(element.first, element.last, display)
			end.html_safe
		end

		def flags_title flags_hash
			flags_hash.inject("") do |res, element|
				res << flag_title(element.first, element.last)
			end.html_safe
		end

		def flag code, name, display = false
			label = display ? name : '&nbsp;'
			content_tag :li,  label.html_safe, :class => "flag #{code}", :'data-country' => name, :'data-cc' => code
		end

		def flag_title code, name, display = false
			label = display ? name : '&nbsp;'
			content_tag :li,  label.html_safe, :class => "flag #{code}", :title => name, :'data-cc' => code
		end

		def use_flags size = 16
			stylesheet_link_tag "flags/flags#{size}"
		end
	end
end