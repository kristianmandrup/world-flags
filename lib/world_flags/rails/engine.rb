module WorldFlags
  module Rails
    class Engine < ::Rails::Engine        
    	initializer "setup for rails" do |app|
    		ActionView::Base.send :include, WorldFlags::Helper::View
        app.config.assets.precompile << %r(flags/flag\d\d(?:_semi)?\.png$)
      end
    end
  end
end
