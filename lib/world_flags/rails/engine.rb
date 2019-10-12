module WorldFlags
  module Rails
    class Engine < ::Rails::Engine        
    	initializer "setup for rails" do |app|
    		ActionView::Base.send :include, WorldFlags::Helper::View
        Helper::View.flag_sizes.each do |size|
          app.config.assets.precompile << "flags/flags#{size}.png"
          app.config.assets.precompile << "flags/flags#{size}_semi.png"
        end
      end
    end
  end
end
