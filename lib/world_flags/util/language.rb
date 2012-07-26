require 'world_flags/util/name_enabler'

module WorldFlags
  module Util
    module Language
      attr_writer :languages_map, :hashied_languages

      extend WorldFlags::Util::NameEnabler

      def language_label code, locale
        language code, locale
      end

      def language code = :us, locale = :en 
        locale ||= default_locale_used      
        locale = WorldFlags.locale(locale).to_sym

        locale_languages_map = languages_map[locale] || languages_map[default_locale_used]
        locale_languages_map = languages_map[:en] if locale_languages_map.blank?

        raise "No language-locale map defined for locale: #{locale} or :en in #{locale_languages_map.inspect}" if locale_languages_map.blank?

        # raise("No language map defined for language code: #{code} in #{locale_languages_map[code]}")      
        code_language = locale_languages_map[code] ? locale_languages_map[code] : locale_languages_map[default_code_used]         

        case code_language
        when Array
          code_language.join(',')
        when String
          code_language
        else
          raise "The language in the language map must be either a String or Array, was #{code_language.inspect}"
        end
      rescue Exception => e
        raise e if WorldFlags.raise_error?
        "Undefined"
      end

      def languages
        @languages ||= Languages.new
      end

      def languages= languages
        raise ArgumentError, "Must be a hash, was: #{languages}" unless !languages || languages.kind_of?(Hash)
        @languages = languages
      end

      def languages_map
        @languages_map ||= begin 
          available_locales.inject({}) do |res, loc|
            res[loc] = find_language_map(loc)
            res
          end
        end
      end

      def hashied_languages
        @hashied_languages ||= begin
          case languages
          when Hash
            Hashie::Mash.new languages
          else
            languages
          end
        end
      end

      def find_language_map loc
        hashied_languages.respond_to?(loc) ? hashied_languages.send(loc) : hashied_languages.send(locale(loc))
      rescue
        hashied_languages.send(default_locale_used)
      end
    end
  end
end