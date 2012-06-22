module WorldFlags
  module Generators
    class PublicizeGenerator < ::Rails::Generators::Base
      desc "Publicizes world flags assets (if not using Rails asset pipeline)"

      class_option :stylesheets_dir,  :type => :string, 
                                      :desc => 'The stylesheets folder of your app'

      class_option :images_dir,       :type => :string, 
                                      :desc => 'The images folder of your app'

      class_option :javascripts_dir,  :type => :string, 
                                      :desc => 'The javascripts folder of your app'

      class_option :public_dir,       :type => :string, 
                                      :desc => 'The public root folder of your app'

      def main_flow
        copy_dir asset_src_dir('stylesheets'), stylesheets_dir
        copy_dir asset_src_dir('images'), images_dir
        copy_dir asset_src_dir('javascripts'), images_dir
      end    

      protected

      def copy_dir src, target
        say "Copying: #{src} -> #{target}"        
        copy src, target
      end

      def asset_src_dir folder
        File.expand_path "../../../vendor/assets/#{folder}"
      end

      def javascripts_dir
        options[:stylesheets_dir] || asset_folder('javascripts')
      end

      def stylesheets_dir
        options[:stylesheets_dir] || asset_folder('stylesheets')
      end

      def images_dir
        options[:images_dir] || asset_folder('images')
      end

      def asset_folder folder = nil
        File.join(public_dir, folder)
      end


      def public_dir
        Rails.root.join(options[:public_dir] || 'public')
      end
    end
  end
end

