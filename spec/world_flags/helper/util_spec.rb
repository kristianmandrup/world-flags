require 'spec_helper'

describe WorldFlags::Helper::View do
  include ControllerTestHelpers,
          WorldFlags::Helper::View

  let(:default_size) { 24 }

  before do
    I18n.locale = 'en'

    WorldFlags.config do |c|
      c.auto_select!    
      c.available_locales = [:ar, :en]
      c.reset!
      c.raise_error!
    end
  end

  describe 'customize flag tags and text' do
    before do
      WorldFlags.config do |c|
        c.flag_list_tag = :div
        c.flag_tag = :span
        c.flag_text = ''
      end
    end

    it "should list flags using customized tags and text" do
      output = flags_list 32 do
        flags [:ar]
      end
      output.should == "<div class=\"f32 flags\"><span class=\"flag ar\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Spanish\" data-locale=\"ar\"></span></div>"
    end
  end

  describe 'disable country and language names' do
    before :each do
      WorldFlags.country_name_disable!
      WorldFlags.language_name_disable!
    end

    it "should list flags using customized tags and text" do
      output = flags_list 32 do
        flags [:ar]
      end
      output.should == "<ul class=\"f32 flags\"><li class=\"flag ar\" data-cc=\"ar\" data-locale=\"ar\"></li></ul>"
    end
  end
end
