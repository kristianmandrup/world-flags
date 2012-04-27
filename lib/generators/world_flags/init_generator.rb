module WorldFlags
  module Generators
    class InitGenerator < ::Rails::Generators::Base
      desc "Creates world flags initializer"

      source_root File.dirname(__FILE__) + '/templates'

      def main_flow
        template "world_flags.erb", "config/initializers/world_flags.rb"
      end      
    end
  end
end

