module WorldFlags
  module Util
    module Enabler
      attr_writer :enabled

      def enabled?
        @enabled.nil? ? true : @enabled
      end

      def disable!
        @enabled = false
      end

      def enable!
        @enabled = true
      end
    end
  end
end