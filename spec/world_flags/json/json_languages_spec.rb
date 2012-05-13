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
    WorldFlags.languages = Hashie::Mash.new languages
    WorldFlags.raise_error!
  end

  it "should list flags using Array" do
    output = flags_list 32 do
      flags [:ar, :gb]
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Spanish\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb\" data-cc=\"gb\" data-country_name=\"United Kingdom\" data-language_name=\"English\" data-locale=\"gb\">&nbsp;</li></ul>"
  end
end
