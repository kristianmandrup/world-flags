module WorldFlags
  module Helper
    module Browser
      def self.browser_locale request
        return @browser_locale if @browser_locale
        if lang = request.env["HTTP_ACCEPT_LANGUAGE"]
          lang = lang.split(",").map { |l|
            l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
            l.split(';q=')
          }.first
          @browser_locale = lang.first.split("-").first
        else
          @browser_locale = I18n.default_locale
        end
      end

      def browser_locale
        WorldFlags::Helper::Browser.browser_locale(request)
      end
    end
  end
end