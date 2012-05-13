require 'hashie'
require "world_flags/core_ext"
require "world_flags/helpers"

require 'world_flags/rails/engine' if defined?(::Rails::Engine)

require "world_flags/languages"
require "world_flags/countries"

require "world_flags/lang_util"
require "world_flags/country_util"


module WorldFlags
	class << self
		attr_accessor :auto_select, :raise_error, :default_code, :default_locale

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

		def raise_error!
			@raise_error = true
		end

		def raise_error_off!
			@raise_error = false
		end

		def auto_select?
			auto_select
		end

		def auto_select!
			@auto_select = true
		end

		def label code = :us, options = {:language => :en}
			locale = extract_locale!(options) || default_locale_used || :en
			options[:country] ? country_label(code, locale) : language_label(code, locale)
		end

		def extract_locale! options
			options[:country] ? options.delete(:country) : options.delete(:language)
		end

		# Locale translation helper macros

		def flag_code code = :us
			# ensure that 'en_US' becomes simply 'us'
			code = code.to_s.sub(/^\w+_/, '').downcase
			(locale_flag_map[code.to_sym] || code).to_sym
		end

		def locale code = :us
			flag_locale_map[code.to_sym] || code
		end

		attr_writer :locale_flag_map

		# override using fx 'locale_to_country_code.json' file
		def locale_flag_map
			@locale_flag_map ||= keys_to_sym(locale_flag_hash) 
		end

		def keys_to_sym hash
			hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
		end

		def locale_flag_hash
			{ 
				:en => "us",
  			:da => "dk",
  			:sv => "se",
  			:sq => "al",
  			:nb => "no",
  			:ja => "jp",
  			:uk => "ua"
  		}
  	end		

		def flag_locale_map
			locale_flag_map.hash_revert
		end

		def default_code_used
			WorldFlags.default_code || :us
		end

		def default_locale_used
			WorldFlags.default_locale || I18n.locale
		end

		include WorldFlags::LangUtil
		include WorldFlags::CountryUtil
	end
end
