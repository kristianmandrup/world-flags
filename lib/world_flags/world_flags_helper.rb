module WorldFlagsHelper
	def self.flag_sizes
		[16, 32]
	end

	def flags_list size = 16, &block
		raise "Missing block" unless block_given?
		raise "Supported sizes are only #{WorldFlagsHelper.flag_sizes}" unless WorldFlagsHelper.flag_sizes.include?(size.to_i)
		content_tag :ul, yield, :class => "f#{size}"
	end

	def flags flags_hash
		flags_hash.inject("") do |res, element|
			res << flag(element.first, element.last)
		end.html_safe
	end

	def flag code, name
		content_tag :li,  name.html_safe, :class => "flag #{code}"
	end

	def use_flags size = 16
		stylesheet_link_tag "flags#{size}"
	end
end
