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

      def locales
        [params[:locale], browser_locale, ip_country_code, I18n.default_locale].downcase
      end
    end
  end
end