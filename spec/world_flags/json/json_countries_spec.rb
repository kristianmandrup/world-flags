require 'spec_helper'

describe WorldFlags::Helper::View do
  include ControllerTestHelpers,
          WorldFlags::Helper::View

  def countries locale = :en
    path = File.join(SPEC_DIR, "../config/countries/locale_countries.#{locale}.json")
    JSON.parse File.read(path)
  end

  before do
    WorldFlags.auto_select!
    I18n.locale = :en
    WorldFlags.available_locales = [:da, :sv, :nb, :en]
    WorldFlags.reset!
    WorldFlags.countries = countries
    WorldFlags.raise_error!
  end

  it "should list flags using Array" do
    output = flags_list 32 do
      flags [:ar, :gb]
    end
    output.should == "<ul class=\"f32 flags\"><li class=\"flag ar\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Spanish\" data-locale=\"ar\"></li><li class=\"flag gb\" data-cc=\"gb\" data-country_name=\"United Kingdom\" data-language_name=\"British English\" data-locale=\"gb\"></li></ul>"
  end
end
