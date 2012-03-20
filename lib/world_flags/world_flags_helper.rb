module WorldFlagsHelper
	def flags_list size, &block
		raise "Missing block" unless block_given?
		content_tag :ul, yield, :class => "f#{size}"
	end

	def flags flags_hash
		flags_hash.each_pair do |code, name|
			flag code, name
		end
	end

	def flag code, name
		content_tag :li,  name, :class => "flag #{code}"
	end

	def use_flags size
		stylesheet_link_tag "flags#{size}"
	end
end
