module WorldFlags
  module Helper
  	module Geo
      def self.ip_json
        require "httparty"

        HTTParty.get('http://freegeoip.net/json/')
      end

  		def self.ip_country_code
      	@ip_country_code ||= ip_json.parsed_response['country_code']
      end

  		def ip_country_code
      	WorldFlags::Helper::Geo.ip_country_code
      end
    end
  end
end