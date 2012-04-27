require "world_flags/core_ext"
require "world_flags/helpers"

require 'world_flags/rails/engine' if defined?(::Rails::Engine)

require "world_flags/languages"
require "world_flags/countries"

module WorldFlags
	class << self
		attr_accessor :auto_select, :raise_error, :default_code

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

		def raise_error?
			@raise_error
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

				:sv => :se,
				:'en_UK' => :gb,
				:'en_US' => :us
			}
		end

		def flag_locale_map
			locale_flag_map.hash_revert
		end

		def default_code_used
			WorldFlags.default_code || :en
		end

		# Language helper macros

		def language locale = :en, code = :en
			locale ||= default_code_used
			locale_languages_map = languages[locale] || languages[default_code_used]

			raise "No language-locale map defined for locale: #{locale} in #{languages}" if locale_languages_map.blank?

			# raise("No language map defined for language code: #{code} in #{locale_languages_map[code]}")			
			locale_languages_map[code] ? locale_languages_map[code] : locale_languages_map[default_code_used] 
		rescue Exception => e
			raise e if WorldFlags.raise_error?
			"Undefined"
		end

		def languages= languages
			raise ArgumentError, "Must be a hash, was: #{languages}" unless languages.kind_of?(Hash)
			@languages = languages
		end

		def languages
			@languages ||= begin 
				active_locales.inject({}) do |res, loc|
					res[locale] = find_language_map(loc)
					res
				end
			end
		end

		def find_language_map loc
			# return Countries.send(loc) if Countries.respond_to?(loc)
			[loc, flag_code(loc), locale(loc)].each do |code|
				return Languages.send(locale) if Languages.respond_to?(locale)
			end
		end

		# Country helper macros

		def country locale = :en, code = :en
			locale ||= default_code_used

			locale_countries_map = countries[locale] || countries[default_code_used]

			raise "No country-locale map defined for locale: #{locale} in #{countries}" if locale_countries_map.blank?

			# raise("No country map defined for country code: #{code} in #{locale_countries_map[code]}")
			locale_countries_map[code] ? locale_countries_map[code] : locale_countries_map[default_code_used] 
		rescue Exception => e
			raise e if WorldFlags.raise_error?
			"Undefined"
		end

		def countries= countries
			raise ArgumentError, "Must be a hash, was: #{countries}" unless countries.kind_of?(Hash)
			@countries = countries
		end

		def countries
			@countries ||= begin 
				active_locales.inject({}) do |res, loc|
					res[loc] = find_country_map(loc)
					res
				end
			end
		end		

		def find_country_map loc
			# return Countries.send(loc) if Countries.respond_to?(loc)
			[loc, flag_code(loc), locale(loc)].each do |code|
				return Countries.send(code) if Countries.respond_to?(code)
			end
		end
	end
end
