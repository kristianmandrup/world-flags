require "world_flags/core_ext"
require "world_flags/helpers"

require 'world_flags/rails/engine' if defined?(::Rails::Engine)

require "world_flags/languages"
require "world_flags/countries"

module WorldFlags
	class << self
		attr_accessor :auto_select

		# TODO: Why both active and valid locales? Does this even make sense!?
		attr_writer :active_locales

		def active_locales
			@active_locales ||= I18n.available_locales unless I18n.available_locales.blank?
			@active_locales ||= [:en]
		end

		# for WorldFlags::Helper::Locale
    def valid_locales
      @valid_locales ||= ['en', 'de', 'es', 'ru']
    end

		def valid_locales= *list
			raise ArgumentError, "Must be a list of locales, was #{list}" if list.empty?
			@valid_locales ||= list.flatten
		end

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

		def locale code
			flag_locale_map[code.to_sym] || code
		end

		attr_writer :locale_flag_map

		# translate locales to flag code: ISO_3166-1_alpha-2
		def locale_flag_map
			@locale_map ||= {
				:en => :us,
				:da => :dk,
				:'en_UK' => :gb,
				:'en_US' => :us
			}
		end

		def flag_locale_map
			locale_flag_map.hash_revert
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
			@languages ||= begin 
				active_locales.inject({}) do |res, locale|
					res[locale] = Languages.send(locale) if Languages.respond_to?(locale)
					res
				end
			end
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
