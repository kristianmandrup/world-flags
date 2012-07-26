module WorldFlags
  module Util
    module NameEnabler
      attr_writer :name_enabled

      def name_enabled?
        @name_enabled.nil? ? true : @name_enabled
      end

      def name_disable!
        @name_enabled = false
      end

      def name_enable!
        @name_enabled = true
      end
    end
  end
end