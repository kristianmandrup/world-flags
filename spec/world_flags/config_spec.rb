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

  describe 'WorldFlags#locale' do
    it 'should translate flag code to locale' do
      WorldFlags.locale('dk').to_s.should == 'da'
    end
  end
end