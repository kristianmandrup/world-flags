module WorldFlags
  module Helper
    module Locale
      def set_locale    
        I18n.locale = locales.select_first_in(valid_locales.downcase)
      end  

      def valid_locales
        if I18n.respond_to?(:available_locales) && I18n.available_locales.present?
          I18n.available_locales
        else
          WorldFlags.valid_locales
        end
      end

      # ensure all country/language/domain types are mapped to their equivalent locale code
      def locales
        locale_sources.compact.downcase.map {|loc| WorldFlags.locale(loc) unless loc.blank? }
      end

      def locale_sources
        [params[:locale], extract_locale_from_tld, browser_locale, ip_country_code, I18n.default_locale]
      end
 
      # Get locale from top-level domain or return nil if such locale is not available
      # You have to put something like:
      #   127.0.0.1 application.com
      #   127.0.0.1 application.it
      #   127.0.0.1 application.pl
      # in your /etc/hosts file to try this out locally
      def extract_locale_from_tld
        I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale  : nil
      end      

      def parsed_locale
        WorldFlags.locale(parsed_domain)
      end

      def parsed_domain
        request.host.split('.').last
      end
    end
  end
end