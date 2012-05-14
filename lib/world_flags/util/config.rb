module WorldFlags
  module Util
    module Config
      attr_accessor :auto_select, :raise_error
      attr_accessor :default_code, :default_locale
      attr_writer   :locale_source_priority

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
        self.countries_map = nil

        self.languages_map = nil
        self.languages = nil
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