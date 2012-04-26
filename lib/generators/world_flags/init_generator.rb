module WorldFlags
  module Generators
    class InitGenerator < Rails::Generators::Base
      desc "Creates locales initializer"

      source_root File.dirname(__FILE__) + '/templates'

      def main_flow
        template "locale.erb", "config/locales/#{locale}/#{file}"
      end      
    end
  end
end

