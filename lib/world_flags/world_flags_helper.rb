module WorldFlagsHelper
	def self.flag_sizes
		[16, 32]
	end

	def flags_list size = 16, &block
		raise "Missing block" unless block_given?
		raise "Supported sizes are only #{WorldFlagsHelper.flag_sizes}" unless WorldFlagsHelper.flag_sizes.include?(size.to_i)
		content = capture(&block)
		content_tag :ul, content, :class => "f#{size}"
	end
	alias_method :flag_list, :flags_list

	def flags flags_hash
		flags_hash.inject("") do |res, element|
			res << flag(element.first, element.last)
		end.html_safe
	end

	def flags_title flags_hash
		flags_hash.inject("") do |res, element|
			res << flag_title(element.first, element.last)
		end.html_safe
	end

	def flag code, name
		content_tag :li,  name.html_safe, :class => "flag #{code}"
	end

	def flag_title code, name
		content_tag :li,  '&nbsp;'.html_safe, :class => "flag #{code}", :title => name
	end

	def use_flags size = 16
		stylesheet_link_tag "flags/flags#{size}"
	end
end
