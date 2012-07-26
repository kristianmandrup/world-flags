module WorldFlags
  class GeoIPError < StandardError; end

  module Helper
  	module Geo
  		def self.country_code_from_ip ip = nil
        ip ||= request.remote_ip
        raise WorldFlags::GeoIPError, "IP address #{ip} is a localhost address" if local_ip?(ip)
        
        # puts "find country code for ip: #{ip}" if debug?

        @geoip ||= ::GeoIP.new WorldFlags.geo_ip_db_path
        country = @geoip.country(ip)
        return country[2] unless country.nil?
      rescue Exception => e
        raise WorldFlags::GeoIPError, "No country code could be found for IP: #{ip} - #{e}"
      end

      def self.local_ip? ip
        WorldFlags.localhost_list.include?(ip)
      end

      def self.debug?
        WorldFlags.debug?
      end

  		def country_code_from_ip ip = nil
      	WorldFlags::Helper::Geo.country_code_from_ip ip
      end
    end
  end
end