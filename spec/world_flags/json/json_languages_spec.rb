require 'spec_helper'

describe WorldFlags::Helper::View do
  include ControllerTestHelpers,
          WorldFlags::Helper::View

  def languages locale = :en
    path = File.join(SPEC_DIR, "../config/languages/locale_languages.#{locale}.json")
    JSON.parse(File.read(path))
  end

  before do
    WorldFlags.auto_select!
    I18n.locale = :en
    WorldFlags.available_locales = [:da, :sv, :nb, :en]
    WorldFlags.reset!
    WorldFlags.languages = languages
    WorldFlags.raise_error!
  end

  it "should list flags using Array" do
    output = flags_list 32 do
      flags [:ar, :gb]
    end
    output.should == "<ul class=\"f32 flags\"><li class=\"flag ar\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"es-ar:Spanish\" data-locale=\"ar\"></li><li class=\"flag gb\" data-cc=\"gb\" data-country_name=\"United Kingdom\" data-language_name=\"en-gb:English\" data-locale=\"gb\"></li></ul>"
  end

  it "should list flags for Zaire with multiple language combis" do
    output = flags_list 32 do
      flags [:tw]
    end
    output.should == "<ul class=\"f32 flags\"><li class=\"flag tw\" data-cc=\"tw\" data-country_name=\"Taiwan\" data-language_name=\"zh:Chinese,zh-tw:Taiwanese\" data-locale=\"tw\"></li></ul>"
  end
end
