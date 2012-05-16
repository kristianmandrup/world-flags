module WorldFlags
  module Helper
  	module Geo
  		def self.ip_country_code
        @geoip ||= GeoIP.new WorldFlags.geo_ip_location
        remote_ip = request.remote_ip unless WorldFlags.localhost_list.include?(remote_ip)
        location_location = @geoip.country(remote_ip)
        if location_location != nil     
          @model.country = location_location[2]
        end
      end

  		def ip_country_code
      	WorldFlags::Helper::Geo.ip_country_code
      end
    end
  end
end