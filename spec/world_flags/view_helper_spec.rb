require 'spec_helper'

describe WorldFlags::Helper::View do
  include ControllerTestHelpers,
          WorldFlags::Helper::View

  before do
    WorldFlags.auto_select!
    I18n.locale = 'ar'
    WorldFlags.active_locales = [:da, :sv, :nb, :en, :ar]

    WorldFlags.raise_error!
  end

  it "should be empty, with an empty block" do
    output = flags_list do
    end
    output.should == "<ul class=\"f16\"></ul>"
  end

  it "should work with alias :flag_list" do
    output = flag_list do
    end
    output.should == "<ul class=\"f16\"></ul>"
  end

  it "should set size to 16 or 32" do
    lambda do flags_list(8) { }    	
    end.should raise_error
  end

  it "should set size to 16 or 32" do
    output = flags_list 32 do
    end
    output.should == "<ul class=\"f32\"></ul>"
  end

  it "should list flags using Array" do
    output = flags_list 32 do
      flags [:ar, :gb]
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar selected\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Argentinian Spanish\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb\" data-cc=\"gb\" data-country_name=\"Great Britain\" data-language_name=\"British English\" data-locale=\"gb\">&nbsp;</li></ul>"
  end

  it "should list flags using args" do
    output = flags_list 32 do
      flags :ar, :gb
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar selected\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Argentinian Spanish\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb\" data-cc=\"gb\" data-country_name=\"Great Britain\" data-language_name=\"British English\" data-locale=\"gb\">&nbsp;</li></ul>"
  end

  it "should list flags using args and :with_semi" do
    output = flags_list 32 do
      flags :ar, :gb, :with_semi => true
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar selected\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Argentinian Spanish\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb semi\" data-cc=\"gb\" data-country_name=\"Great Britain\" data-language_name=\"British English\" data-locale=\"gb\">&nbsp;</li></ul>"
  end

  it "should list flags" do
    output = flag_title :ar, 'Argentina'
    output.should == "<li class=\"flag ar selected\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Argentinian Spanish\" data-locale=\"ar\" title=\"Argentina\">&nbsp;</li>"
  end

  describe 'Countries' do
    context 'Danish locale' do
      before do
        I18n.locale = 'da'
      end

      it "should list nordic flags using args and :with_semi" do
        output = flags_list 32 do
          flags :dk, :se, :no, :with_semi => true, :country => :da
        end
        output.should == "<ul class=\"f32\"><li class=\"flag dk selected\" data-cc=\"dk\" data-country_name=\"Danmark\" data-language_name=\"Dansk\" data-locale=\"dk\">&nbsp;</li><li class=\"flag se semi\" data-cc=\"se\" data-country_name=\"USA\" data-language_name=\"Svensk\" data-locale=\"se\">&nbsp;</li><li class=\"flag no semi\" data-cc=\"no\" data-country_name=\"Norge\" data-language_name=\"Norsk\" data-locale=\"no\">&nbsp;</li></ul>"
      end
    end

    context 'Swedish locale' do
      before do
        I18n.locale = 'sv'
      end

      it "should list nordic flags using args and :with_semi" do
        output = flags_list 32 do
          flags :dk, :se, :no, :with_semi => true, :country => :da
        end
        output.should == "<ul class=\"f32\"><li class=\"flag dk semi\" data-cc=\"dk\" data-country_name=\"Danmark\" data-language_name=\"Dansk\" data-locale=\"dk\">&nbsp;</li><li class=\"flag se selected\" data-cc=\"se\" data-country_name=\"USA\" data-language_name=\"Svenska\" data-locale=\"se\">&nbsp;</li><li class=\"flag no semi\" data-cc=\"no\" data-country_name=\"Norge\" data-language_name=\"Norsk\" data-locale=\"no\">&nbsp;</li></ul>"
      end
    end

    context 'Norwegian locale' do
      before do
        I18n.locale = 'nb'
      end

      it "should list nordic flags using args and :with_semi" do
        output = flags_list 32 do
          flags :dk, :se, :no, :with_semi => true, :country => :da
        end
        output.should == "<ul class=\"f32\"><li class=\"flag dk semi\" data-cc=\"dk\" data-country_name=\"Danmark\" data-language_name=\"Dansk\" data-locale=\"dk\">&nbsp;</li><li class=\"flag se semi\" data-cc=\"se\" data-country_name=\"Sverige\" data-language_name=\"Svensk\" data-locale=\"se\">&nbsp;</li><li class=\"flag no selected\" data-cc=\"no\" data-country_name=\"Norge\" data-language_name=\"Norsk\" data-locale=\"no\">&nbsp;</li></ul>"
      end
    end
  end  
end
