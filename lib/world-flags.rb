require "world_flags/world_flags_helper"
require "world_flags/locale_helper"
require "rails"
require 'world_flags/rails_plugin/engine'

ActionView::Base.send :include, WorldFlagsHelper
