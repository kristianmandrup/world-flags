module WorldFlags
  module Helper
    module Locale
      def set_locale    
        I18n.locale = locales.select_first_in(valid_locales.downcase)
      end  

      def valid_locales
        return WorldFlags.available_locales if WorldFlags.available_locales.present?
        if I18n.respond_to?(:available_locales) && I18n.available_locales.present?
          I18n.available_locales
        else
          raise "You must define a list of available locales for use with WorldFlags either in WorldFlags.available_locales or I18n.available_locales"
        end
      end

      # ensure all country/language/domain types are mapped to their equivalent locale code
      def locales
        locale_sources.compact.downcase.map {|loc| WorldFlags.locale(loc) unless loc.blank? }
      end

      def locale_sources
        locale_source_priority.inject([]) do |res, name|
          res << locale_priority(name)
          res
        end
      end

      def locale_priority name
        case name.to_sym
        when :param
          params[:locale]
        when :domain
          extract_locale_from_tld # http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains
        when :browser
          browser_locale # http://www.metamodpro.com/browser-language-codes
        when :ip
          get_country_by_ip          
        when :default
          I18n.default_locale
        end
      end

      def get_country_by_ip
        country_code_from_ip browser_ip
      rescue WorldFlags::GeoIPError
        I18n.default_locale
      end

      def browser_ip
        request.remote_ip
      end

      def locale_source_priority
        WorldFlags.locale_source_priority
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
        WorldFlags.domain_to_locale(parsed_domain)
      end

      def parsed_domain
        request.host.split('.').last
      end
    end
  end
end