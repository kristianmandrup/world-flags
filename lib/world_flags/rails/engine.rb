module WorldFlags
  module Rails
    class Engine < ::Rails::Engine        
    	initializer "setup for rails" do
    		WorldFlags::Rails::Engine.add_view_ext
      end

    	def self.add_view_ext
    		ActionView::Base.send :include, WorldFlags::ViewHelper
    	end
    end
  end
end
