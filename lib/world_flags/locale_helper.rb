require "httparty"

module WorldFlags
	module Geo
    def self.ip_json
      HTTParty.get('http://freegeoip.net/json/')
    end

		def self.ip_country_code
    	@ip_country_code ||= ip_json.parsed_response['country_code']
    end

		def ip_country_code
    	WorldFlags::Geo.ip_country_code
    end
  end

  module Browser
		def self.browser_locale
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
   		WorldFlags::Browser.browser_locale
   	end
  end

  module All
  	def self.included(base)
  		base.send :include, Geo
  		base.send :include, Browser
  	end
  end
end