require "world_flags/view_helper"
require "world_flags/locale_helper"
require 'world_flags/rails/engine' if defined?(::Rails::Engine)

require "world_flags/languages"
require "world_flags/countries"

module WorldFlags
	class << self
		attr_accessor :auto_select

		def auto_select?
			auto_select
		end

		def auto_select!
			@auto_select = true
		end

		def label code = :en, options = {:language => :en}			
			label = options[:country] ? WorldFlags.country(options[:country], code) : WorldFlags.language(options[:language], code)
			# if all else fails
			default_locale = I18n.locale || :en
			label ||= WorldFlags.language(default_locale, code)
		end

		# Locale translation helper macros

		def flag_code code
			locale_flag_map[code.to_sym] || code
		end

		attr_accessor :locale_flag_map

		# translate locales to flag code: ISO_3166-1_alpha-2
		def locale_flag_map
			@locale_map ||= {
				:en => :gb,
				:da => :dk
			}
		end

		# Language helper macros

		def language locale = :en, code = :en
			locale ||= :en
			languages[locale][code]
		end

		def languages= languages
			raise ArgumentError, "Must be a hash, was: #{languages}" unless languages.kind_of?(Hash)
			@languages = languages
		end

		def languages
			@languages ||= {:en => Languages.en}
		end

		# Country helper macros

		def country locale = :en, code = :en
			locale ||= :en
			countries[locale][code]
		end

		def countries= countries
			raise ArgumentError, "Must be a hash, was: #{countries}" unless countries.kind_of?(Hash)
			@countries = countries
		end

		def countries
			@countries ||= {:en => Countries.en}
		end		
	end
end
