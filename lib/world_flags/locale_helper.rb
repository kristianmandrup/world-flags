require "httparty"

class Array
  def downcase
    self.map{|e| e.to_s.downcase}
  end

  def upcase
    self.map{|e| e.to_s.upcase}
  end

  def select_first_in *list
    list = list.flatten.compact   
    self.each {|e| return e if list.include?(e) }
  end
end

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

  module Locale
    def set_locale    
      I18n.locale = locales.select_first_in(valid_locales.downcase)
    end  

    class << self
      attr_writer :valid_locales

      def valid_locales
        @valid_locales ||= ['en', 'de', 'es', 'ru']
      end
    end

    def locales
      [params[:locale], browser_locale, ip_country_code, I18n.default_locale].downcase
    end    
  end

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
   		WorldFlags::Browser.browser_locale(request)
   	end
  end

  module All
  	def self.included(base)
  		base.send :include, Geo
  		base.send :include, Browser
      base.send :include, Locale
  	end
  end
end