require 'spec_helper'

describe WorldFlags::ViewHelper do
  include ControllerTestHelpers,
          WorldFlags::ViewHelper

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

  it "should list flags" do
    output = flags_list 32 do
    	flags :ar => 'Argentina', :gb => 'England'
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar\" data-cc=\"ar\" data-country=\"Argentina\">Argentina</li><li class=\"flag gb\" data-cc=\"gb\" data-country=\"England\">England</li></ul>"
  end

  it "should list flags" do
    output = flag_title :ar, 'Argentina'
    output.should == "<li class=\"flag ar\" data-cc=\"ar\" title=\"Argentina\">&nbsp;</li>"
  end

  it "should list flags" do
    output = flags_list 32 do
    	flags_title :ar => 'Argentina'
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar\" data-cc=\"ar\" title=\"Argentina\">&nbsp;</li></ul>"
  end

  it "should list flags combined" do
    output = flags_list 32 do
    	[flags(:ar => 'Argentina', :gb => 'England'), flag(:br, 'Brazil')].join.html_safe 
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar\" data-cc=\"ar\" data-country=\"Argentina\">Argentina</li><li class=\"flag gb\" data-cc=\"gb\" data-country=\"England\">England</li><li class=\"flag br\" data-cc=\"br\" data-country=\"Brazil\">Brazil</li></ul>"
  end
end

