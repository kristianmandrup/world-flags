# require 'generators/world_flags/redirect_follower'
require 'resourceful'
require 'mechanize'
require 'zip/zip'
require 'fileutils'

module WorldFlags
  module Generators
    class GeoipGenerator < ::Rails::Generators::Base
      desc "Copy IP database - GeoIP.dat"

      class_option :local, :type => :boolean, :default => true, :desc => 'Use local cached GeoIP or retrieve latest from maxmind.com'

      source_root File.dirname(__FILE__)

      def main_flow
        local? ? copy_local : download_latest
      end

      protected

      def local?
        !(options[:local] == false)
      end

      def copy_local
        copy_file "GeoIP.dat", "db/GeoIP.dat"
      end

      def download_latest 
        # http = ::Resourceful::HttpAccessor.new
        # resource = http.resource( zip_adr )
        # # resource.on_redirect { |req, resp| resp.header['Location'] =~ /example.com/ }
        # resp = resource.get  # Will only follow the redirect if the new location is example.com

        # puts "get: #{file_name} from #{zip_adr}"

        agent = Mechanize.new  { |agent| agent.user_agent_alias = 'Mac Safari'}
        agent.robots = false

        # puts "robots allowed? #{agent.robots_allowed?}"

        agent.pluggable_parser.default = Mechanize::Download
        agent.get(zip_adr).save(file_name)

        # File.open(file_name, 'w+') do |zip_file|
        #   zip_file.write(resp.body)
        # end
        #zf is an instance of class Tempfile
        # puts "zip path: #{zf.path}"

        Zip::ZipFile.open(file_name) do |zipfile|
          # puts "zipfile: #{zipfile}"
          #zipfile.class is Zip::ZipFile
          zipfile.each do |e|
            #e is an instance of Zip::ZipEntry
            fpath = File.join file_name, e.to_s
            FileUtils.mkdir_p File.dirname(target_location)
            #the block is for handling an existing file. returning true will overwrite the files.
            zipfile.extract(e, target_location) { true }
          end
        end
        FileUtils.rm(file_name) # if options[:cleanup]
      end

      def agent_options
        {"User-Agent" => "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100402 Ubuntu/9.10 (karmic) Firefox/3.5.9", "From" => "foo@bar.com", "Referer" => "http://www.foo.bar/"}
      end

      def target_location
        ::Rails.root.join 'db', 'GeoIP.dat'
      end

      def zip_adr
        "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/#{file_name}"
      end

      def file_name
        'GeoIP.dat.gz'
      end
    end
  end
end



