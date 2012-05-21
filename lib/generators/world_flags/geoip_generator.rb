module WorldFlags
  module Generators
    class GeoipGenerator < ::Rails::Generators::Base
      desc "Copy IP database - GeoIP.dat"

      class_option :local, :type => :boolean, :default => false, :desc => 'Use local cached GeoIP or retrieve latest from maxmind.com'

      source_root File.dirname(__FILE__)

      def main_flow
        options[:local] ? copy_local : download_latest
      end

      protected

      def copy_local
        copy "GeoIP.dat", target_location
      end

      def download_latest   
        require 'curb'

        curl.on_body do |data| 
          File.open(target_location, 'w+') do |file| 
            file.write data
          end
        end
      end

      def target_location
        Rails.root.join 'db', 'GeoIP.dat'
      end

      def curl
        @curl ||= ::Curl::Easy.perform zip_adr
      end

      def zip_adr
        'http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz'
      end
    end
  end
end

