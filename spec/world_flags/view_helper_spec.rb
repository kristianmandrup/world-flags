require 'spec_helper'

describe WorldFlags::Helper::View do
  include ControllerTestHelpers,
          WorldFlags::Helper::View

  before do
    WorldFlags.auto_select!
    I18n.locale = 'ar'
    WorldFlags.active_locales = [:da, :sv, :no, :en, :ar]
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
    output.should == "<ul class=\"f32\"><li class=\"flag ar selected\" data-cc=\"ar\" data-country=\"Argentinian Spanish\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb\" data-cc=\"gb\" data-country=\"British English\" data-locale=\"en_UK\">&nbsp;</li></ul>"
  end

  it "should list flags using args" do
    output = flags_list 32 do
      flags :ar, :gb
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar selected\" data-cc=\"ar\" data-country=\"Argentinian Spanish\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb\" data-cc=\"gb\" data-country=\"British English\" data-locale=\"en_UK\">&nbsp;</li></ul>"
  end

  it "should list flags using args and :with_semi" do
    output = flags_list 32 do
      flags :ar, :gb, :with_semi => true
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar selected\" data-cc=\"ar\" data-country=\"Argentinian Spanish\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb semi\" data-cc=\"gb\" data-country=\"British English\" data-locale=\"en_UK\">&nbsp;</li></ul>"
  end

  it "should list flags" do
    output = flag_title :ar, 'Argentina'
    output.should == "<li class=\"flag ar selected\" data-cc=\"ar\" data-country=\"Argentina\" data-locale=\"ar\" title=\"Argentina\">&nbsp;</li>"
  end

  describe 'Countries' do
    before do
      I18n.locale = 'da'
    end

    it "should list nordic flags using args and :with_semi" do
      output = flags_list 32 do
        flags :dk, :se, :no, :with_semi => true, :country => :da
      end
      output.should == "<ul class=\"f32\"><li class=\"flag dk selected\" data-cc=\"dk\" data-country=\"Danmark\" data-locale=\"da\">&nbsp;</li><li class=\"flag se semi\" data-cc=\"se\" data-country=\"Sverige\" data-locale=\"sv\">&nbsp;</li><li class=\"flag no semi\" data-cc=\"no\" data-country=\"Norge\" data-locale=\"no\">&nbsp;</li></ul>"
    end
  end  
end
