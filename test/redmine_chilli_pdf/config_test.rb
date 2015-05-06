require File.dirname(__FILE__) + '/../test_helper'

class ConfigTest < ActiveSupport::TestCase
  setup do
    Setting["plugin_chilli_pdf"] = HashWithIndifferentAccess.new(ChilliPDF::Config.defaults)
  end

  context '#header_values' do
    context 'when no customizations have taken place' do
      should "return the 'defaults' values for the header fields" do
        defaults = {
                     :left   => ChilliPDF::Config.defaults[ChilliPDF::Config::HEADER_LEFT_KEYNAME],
                     :center => ChilliPDF::Config.defaults[ChilliPDF::Config::HEADER_CENTER_KEYNAME],
                     :right  => ChilliPDF::Config.defaults[ChilliPDF::Config::HEADER_RIGHT_KEYNAME]
                   }
        assert_equal defaults, ChilliPDF::Config.header_values
      end
    end

    context 'when the content has been customized' do
      setup do
        @left   = 'left_header'
        @center = 'center header'
        @right  = 'right header'

        Setting["plugin_chilli_pdf"] = {ChilliPDF::Config::HEADER_LEFT_KEYNAME => @left,
                                       ChilliPDF::Config::HEADER_CENTER_KEYNAME => @center,
                                       ChilliPDF::Config::HEADER_RIGHT_KEYNAME => @right}
      end

      should "return the customized values for the header fields" do
        assert_equal @left, ChilliPDF::Config.header_values[:left]
        assert_equal @center, ChilliPDF::Config.header_values[:center]
        assert_equal @right, ChilliPDF::Config.header_values[:right]
      end
    end
  end

  context '#footer_values' do
    context 'when no customizations have taken place' do
      should "return the 'defaults' values for the footer fields" do
        defaults = {
                     :left   => ChilliPDF::Config.defaults[ChilliPDF::Config::FOOTER_LEFT_KEYNAME],
                     :center => ChilliPDF::Config.defaults[ChilliPDF::Config::FOOTER_CENTER_KEYNAME],
                     :right  => ChilliPDF::Config.defaults[ChilliPDF::Config::FOOTER_RIGHT_KEYNAME]
                   }
        assert_equal defaults, ChilliPDF::Config.footer_values
      end
    end

    context 'when the footer content has been customized' do
      setup do
        @left   = 'left footer'
        @center = 'center footer'
        @right  = 'right footer'

        Setting["plugin_chilli_pdf"] = {ChilliPDF::Config::FOOTER_LEFT_KEYNAME => @left,
                                       ChilliPDF::Config::FOOTER_CENTER_KEYNAME => @center,
                                       ChilliPDF::Config::FOOTER_RIGHT_KEYNAME => @right}
      end

      should "return the customized values for the footer fields" do
        assert_equal @left, ChilliPDF::Config.footer_values[:left]
        assert_equal @center, ChilliPDF::Config.footer_values[:center]
        assert_equal @right, ChilliPDF::Config.footer_values[:right]
      end
    end
  end
end
