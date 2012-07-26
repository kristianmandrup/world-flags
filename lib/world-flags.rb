require 'hashie'
require 'world_flags/core_ext'
require 'world_flags/helpers'

require 'world_flags/rails/engine' if defined?(::Rails::Engine)

require 'world_flags/languages'
require 'world_flags/countries'
require 'world_flags/util'

module WorldFlags
	class << self
		include Util

		attr_writer :active_locales
		attr_writer :locale_flag_map

		attr_writer :flag_tag, :flag_list_tag, :flag_text

    def country_name_enabled?
    	WorldFlags::Util::Country.name_enabled?
    end

    def language_name_enabled?
    	WorldFlags::Util::Language.name_enabled?
    end

    def country_name_enable!
    	WorldFlags::Util::Country.name_enable!
    end

    def language_name_enable!
    	WorldFlags::Util::Language.name_enable!
    end

    def country_name_disable!
    	WorldFlags::Util::Country.name_disable!
    end

    def language_name_disable!
    	WorldFlags::Util::Language.name_disable!
    end


		def flag_text
 			@flag_text ||= '' #' &nbsp;'
 		end

		def flag_tag
			@flag_tag ||= :li
		end

		def flag_list_tag
			@flag_list_tag ||= :ul
		end

		def config &block
  		(block_given? && block.arity == 1) ? yield(self) : instance_eval(&block)
		end

		def label code = :us, options = {:language => :en}
			locale = extract_locale!(options) || default_locale_used || :en
			options[:country] ? country_label(code, locale) : language_label(code, locale)
		end

		def flag_code code = :us
			# ensure that 'en_US' becomes simply 'us'
			code = code.to_s.sub(/^\w+_/, '').downcase
			(locale_flag_map[code.to_sym] || code).to_sym
		end

		def locale code = :us
			flag_locale_map[code.to_sym] || code
		end

		# avoid uk being translated to ukraine for domain names!		
		def domain_to_locale code
			domain_locale_map[code.to_sym] || flag_locale_map[code.to_sym] || code
		end

		def domain_locale_map
			{ 
				:uk => "en_GB",
				:tp => "tl",
				:su => 'ru',
				:an => 'nl'
  		}
  	end


		# override using fx 'locale_to_country_code.json' file
		def locale_flag_map
			@locale_flag_map ||= keys_to_sym(locale_flag_hash) 
		end

		# see core_ext
		def flag_locale_map
			@flag_locale_map ||= keys_to_sym(locale_flag_map.hash_revert)
		end

		protected

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

		def extract_locale! options
			options[:country] ? options.delete(:country) : options.delete(:language)
		end		
	end
end
