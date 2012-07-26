require 'world_flags/util/name_enabler'

module WorldFlags
  module Util
    module Country
      attr_writer :countries_map, :hashied_countries
      
      extend WorldFlags::Util::NameEnabler

      def country_label code, locale
        WorldFlags.country code, locale
      end

      def country code = :us, locale = :en
        locale ||= default_locale_used
        locale = WorldFlags.locale(locale).to_sym

        locale_countries_map = countries_map[locale] || countries_map[default_locale_used]
        locale_countries_map = countries_map[:en] if locale_countries_map.blank?

        raise "No country-locale map defined for locale: #{locale} or :en in #{countries.inspect}" if locale_countries_map.blank?

        # raise("No country map defined for country code: #{code} in #{locale_countries_map[code]}")
        locale_countries_map[code] ? locale_countries_map[code] : locale_countries_map[default_code_used] 
      rescue Exception => e
        raise e if WorldFlags.raise_error?
        "Undefined"
      end

      def countries= countries
        raise ArgumentError, "Must be a hash, was: #{countries}" unless !countries || countries.kind_of?(Hash)
        @countries = countries
      end

      def countries
        @countries ||= Countries.new
      end

      def countries_map
        @countries_map ||= begin 
          available_locales.inject({}) do |res, loc|
            res[loc] = find_country_map(loc)
            res
          end
        end
      end   

      def hashied_countries
        @hashied_countries ||= begin
          case countries
          when Hash
            Hashie::Mash.new countries
          else
            countries
          end
        end
      end

      def find_country_map loc        
        hashied_countries.respond_to?(loc) ? hashied_countries.send(loc) : hashied_countries.send(locale loc)
      rescue
        hashied_countries.send(default_locale_used)
      end
    end
  end
end