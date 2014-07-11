module WorldFlags
  module Util
    module Config
      attr_accessor :auto_select, :raise_error, :debug
      attr_accessor :default_code, :default_locale
      attr_writer   :locale_source_priority, :geo_ip_db_path, :localhost_list

      def debug?
        @debug
      end

      def debug_on!
        @debug = true
      end

      def debug_off!
        @debug = false
      end

      def geo_ip_db_path
        @geo_ip_db_path ||= ::Rails.root.join 'db', 'GeoIP.dat'
      end

      def localhost_list
        @localhost_list ||= ["127.0.0.1", "localhost", "0.0.0.0"]
      end

      def locale_source_priority
        @locale_source_priority ||= default_locale_source_priority
      end

      def default_locale_source_priority
        supported_locale_source_priorities
      end

      def supported_locale_source_priorities
        [:param, :domain, :browser, :ip, :default]
      end

      def reset!
        raise_error_off!
        auto_select_off!

        self.countries = nil
        self.hashied_countries = nil
        self.countries_map = nil

        self.languages_map = nil
        self.hashied_languages = nil
        self.languages = nil

        self.flag_text = ''
        self.flag_tag = :li
        self.flag_list_tag = :ul

        self.country_name_enable!
        self.language_name_enable!
      end

      def default_code_used
        WorldFlags.default_code || :us
      end

      def default_locale_used
        WorldFlags.default_locale || I18n.locale
      end

      def available_locales
        @available_locales ||= I18n.available_locales unless I18n.available_locales.blank?
        @available_locales ||= default_locales
      end

      def available_locales= *list
        raise ArgumentError, "Must be a list of locales, was #{list}" if list.empty?
        @available_locales = list.flatten
      end

      def default_locales
        ['en', 'fr', 'es', 'ru']
      end

      def auto_select?
        auto_select
      end

      def auto_select!
        @auto_select = true
      end

      def auto_select_off!
        @auto_select = true
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
    end
  end
end
