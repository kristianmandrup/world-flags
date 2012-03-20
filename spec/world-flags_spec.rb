require 'spec_helper'

describe WorldFlagsHelper do
  include ControllerTestHelpers,
          WorldFlagsHelper

  it "should be empty, with an empty block" do
    output = flags_list do
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
    	flags :ar => 'Argentina', :en => 'England'
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar\">Argentina</li><li class=\"flag en\">England</li></ul>"
  end

  it "should list flags combined" do
    output = flags_list 32 do
    	[flags(:ar => 'Argentina', :en => 'England'), flag(:br, 'Brazil')].join.html_safe 
    end
    output.should == "<ul class=\"f32\"><li class=\"flag ar\">Argentina</li><li class=\"flag en\">England</li><li class=\"flag br\">Brazil</li></ul>"
  end
end

