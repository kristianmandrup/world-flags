module WorldFlags
	module Helper
	  module All
	  	def self.included(base)
	  		[:Geo, :Browser, :Locale].each do |name|
	  			base.send :include, "WorldFlags::Helper::#{name}".constantize
	  		end
	  	end
	  end
	end
end