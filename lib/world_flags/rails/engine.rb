module WorldFlags
  module Rails
    class Engine < ::Rails::Engine        
    	initializer "setup for rails" do
    		ActionView::Base.send :include, WorldFlags::Helper::View
      end
    end
  end
end
