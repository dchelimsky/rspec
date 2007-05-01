require File.dirname(__FILE__) + '/../../spec_helper'

['model','view','helper'].each do |context|
  describe "A #{context} spec should be able to access 'test/unit' assertions", :behaviour_type => context.to_sym do

    it "like assert_equal" do
      assert_equal 1, 1
      lambda {
        assert_equal 1, 2
      }.should raise_error(Test::Unit::AssertionFailedError)
    end

  end
end

['integration', 'isolation'].each do |mode|
  describe "A controller spec in #{mode} mode should be able to access 'test/unit' assertions", :behaviour_type => :controller do
    controller_name :controller_spec
    integrate_views if mode == 'integration'

    it "like assert_equal" do
      assert_equal 1, 1
      lambda {
        assert_equal 1, 2
      }.should raise_error(Test::Unit::AssertionFailedError)
    end
  end
end
