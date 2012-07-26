require 'world_flags/helper/view/util'

module WorldFlags
	module Helper
		module View
			def self.flag_sizes
				[16, 24, 32, 48, 64]
			end

			def flags_list size = 24, options = {}, &block
				raise "Missing block" unless block_given?
				unless WorldFlags::Helper::View.flag_sizes.include?(size.to_i)
					raise "Supported sizes are only #{WorldFlags::Helper::View.flag_sizes}" 
				end
				content = capture(&block)
				xclass = options[:class] ? " #{options[:class]}" : ''
				content_tag WorldFlags.flag_list_tag, content, :class => "f#{size} flags#{xclass}"
			end
			alias_method :flag_list, :flags_list

			# http://en.wikipedia.org/wiki/ISO_639-1_language_matrix

			# should look up translation for each code
			def flags *args
				options = args.extract_options!
				args.flatten!
				args.inject("") do |res, elem|
					case elem
					when String, Symbol
						code = elem
						name = WorldFlags.label(code, options)
					else
						raise ArgumentError, "Bad argument: #{args}, must be Array"
					end				
					res << flag(code, name, options)
				end.html_safe
			end

			def flags_title *args
				options = args.extract_options!
				flags args, options.merge(:title => true)
			end

			def flag code, *args
				options = args.extract_options!
				name = args.first.kind_of?(String) ? args.first : WorldFlags.label(code, options)				

				label = WorldFlags::Helper::View::Util.label_for options
				title = WorldFlags::Helper::View::Util.title_for name, options

				content_tag WorldFlags.flag_tag, label.html_safe, WorldFlags::Helper::View::Util.flag_options(code, title, name, options)
			end

			def flag_title code, *args
				options = args.extract_options!
				name = args.first.kind_of?(String) ? args.first : WorldFlags.label(code, options)				

				flag code, name, options.merge(:title => true)
			end

			def use_flags size = 24
				stylesheet_link_tag "flags/flags#{size}"
			end
		end
	end
end