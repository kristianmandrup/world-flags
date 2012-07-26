require 'spec_helper'

describe WorldFlags::Helper::View do
  include ControllerTestHelpers,
          WorldFlags::Helper::View

  let(:default_size) { 24 }

  before do
    I18n.locale = 'ar'

    WorldFlags.config do |c|
      c.auto_select!    
      c.available_locales = [:da, :sv, :nb, :en]
      c.reset!
      c.raise_error!
    end
  end

  describe '#flags_list' do
    it "should be empty, with an empty block" do
      output = flags_list do
      end
      output.should == "<ul class=\"f#{default_size} flags\"></ul>"
    end

    it "should work with alias :flag_list" do
      output = flag_list do
      end
      output.should == "<ul class=\"f#{default_size} flags\"></ul>"
    end

    it "should raise error when unsupported flag size" do
      lambda do flags_list(8) { }    	
      end.should raise_error
    end

    it "should set size to 16 or 32" do
      output = flags_list 32 do
      end
      output.should == "<ul class=\"f32 flags\"></ul>"
    end
  end

  describe '#flags' do
    it "should list flags using Array" do
      output = flags_list 32 do
        flags [:ar, :gb]
      end
      output.should == "<ul class=\"f32 flags\"><li class=\"flag ar selected\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Spanish\" data-locale=\"ar\"></li><li class=\"flag gb\" data-cc=\"gb\" data-country_name=\"United Kingdom\" data-language_name=\"British English\" data-locale=\"gb\"></li></ul>"
    end

    it "should list flags using args" do
      output = flags_list 32 do
        flags :ar, :gb
      end
      output.should == "<ul class=\"f32 flags\"><li class=\"flag ar selected\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Spanish\" data-locale=\"ar\"></li><li class=\"flag gb\" data-cc=\"gb\" data-country_name=\"United Kingdom\" data-language_name=\"British English\" data-locale=\"gb\"></li></ul>"
    end

    it "should list flags using args and :with_semi" do
      output = flags_list 32 do
        flags :ar, :gb, :with_semi => true
      end
      output.should == "<ul class=\"f32 flags\"><li class=\"flag ar selected\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Spanish\" data-locale=\"ar\"></li><li class=\"flag gb semi\" data-cc=\"gb\" data-country_name=\"United Kingdom\" data-language_name=\"British English\" data-locale=\"gb\"></li></ul>"
    end
  end

  describe '#flag' do
    it "should create a flag tag" do
      output = flag :ar, 'Argentina'
      output.should == "<li class=\"flag ar selected\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Spanish\" data-locale=\"ar\"></li>"
    end
  end

  describe '#flag_title' do
    it "should list flags" do
      output = flag_title :ar, 'Argentina'
      output.should == "<li class=\"flag ar selected\" data-cc=\"ar\" data-country_name=\"Argentina\" data-language_name=\"Spanish\" data-locale=\"ar\" title=\"Argentina\"></li>"
    end
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
        output.should == "<ul class=\"f32 flags\"><li class=\"flag dk selected\" data-cc=\"dk\" data-country_name=\"Danmark\" data-language_name=\"Dansk\" data-locale=\"da\"></li><li class=\"flag se semi\" data-cc=\"se\" data-country_name=\"Sverige\" data-language_name=\"Svensk\" data-locale=\"sv\"></li><li class=\"flag no semi\" data-cc=\"no\" data-country_name=\"Norge\" data-language_name=\"Norsk\" data-locale=\"nb\"></li></ul>"
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
        output.should == "<ul class=\"f32 flags\"><li class=\"flag dk semi\" data-cc=\"dk\" data-country_name=\"Danmark\" data-language_name=\"Dansk\" data-locale=\"da\"></li><li class=\"flag se selected\" data-cc=\"se\" data-country_name=\"Sverige\" data-language_name=\"Svenska\" data-locale=\"sv\"></li><li class=\"flag no semi\" data-cc=\"no\" data-country_name=\"Norge\" data-language_name=\"Norsk\" data-locale=\"nb\"></li></ul>"
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
        output.should == "<ul class=\"f32 flags\"><li class=\"flag dk semi\" data-cc=\"dk\" data-country_name=\"Danmark\" data-language_name=\"Dansk\" data-locale=\"da\"></li><li class=\"flag se semi\" data-cc=\"se\" data-country_name=\"Sverige\" data-language_name=\"Svensk\" data-locale=\"sv\"></li><li class=\"flag no selected\" data-cc=\"no\" data-country_name=\"Norge\" data-language_name=\"Norsk\" data-locale=\"nb\"></li></ul>"
      end
    end
  end  
end
