require 'spec_helper'

describe WorldFlags::Helper::View do
  include ControllerTestHelpers,
          WorldFlags::Helper::View

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

  it "should list flags using Hash arg" do
    output = flags_list 32 do
    	flags :ar => 'Argentina', :gb => 'England', :dk => 'Denmark'
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar \" data-cc=\"ar\" data-country=\"Argentina\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb \" data-cc=\"gb\" data-country=\"England\" data-locale=\"en_UK\">&nbsp;</li><li class=\"flag dk \" data-cc=\"dk\" data-country=\"Denmark\" data-locale=\"da\">&nbsp;</li></ul>"
  end

  it "should list flags using Array" do
    output = flags_list 32 do
      flags [:ar, :gb]
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar \" data-cc=\"ar\" data-country=\"Argentinian Spanish\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb \" data-cc=\"gb\" data-country=\"British English\" data-locale=\"en_UK\">&nbsp;</li></ul>"
  end

  it "should list flags" do
    output = flag_title :ar, 'Argentina'
    output.should == "<li class=\"flag ar \" data-cc=\"ar\" data-country=\"Argentina\" data-locale=\"ar\" title=\"Argentina\">&nbsp;</li>"
  end

  it "should list flags" do
    output = flags_list 32 do
    	flags_title :ar => 'Argentina'
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar \" data-cc=\"ar\" data-country=\"Argentina\" data-locale=\"ar\" title=\"Argentina\">&nbsp;</li></ul>"
  end

  it "should list flags combined" do
    output = flags_list 32 do
    	[flags(:ar => 'Argentina', :gb => 'England'), flag(:br, 'Brazil')].join.html_safe 
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar \" data-cc=\"ar\" data-country=\"Argentina\" data-locale=\"ar\">&nbsp;</li><li class=\"flag gb \" data-cc=\"gb\" data-country=\"England\" data-locale=\"en_UK\">&nbsp;</li><li class=\"flag br \" data-cc=\"br\" data-country=\"Brazil\" data-locale=\"br\">&nbsp;</li></ul>"
  end
end

