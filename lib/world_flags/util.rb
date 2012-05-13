require "world_flags/util/language"
require "world_flags/util/country"
require "world_flags/util/config"

module WorldFlags
  module Util
    def self.included base
      base.send :include, Language
      base.send :include, Country
      base.send :include, Config
    end
  end
end