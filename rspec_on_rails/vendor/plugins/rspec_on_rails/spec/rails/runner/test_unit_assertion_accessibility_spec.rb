require File.dirname(__FILE__) + '/../../spec_helper'

['model','view','helper'].each do |context|
  context "A #{context} spec should be able to access 'test/unit' assertions", :context_type => context.to_sym do

    specify "like assert_equal" do
      assert_equal 1, 1
      lambda {
        assert_equal 1, 2
      }.should_raise Test::Unit::AssertionFailedError
    end

  end
end

['integration', 'isolation'].each do |mode|
  context "A controller spec in #{mode} mode should be able to access 'test/unit' assertions", :context_type => :controller do
    controller_name :controller_isolation_spec
    integrate_views if mode == 'integration'

    specify "like assert_equal" do
      assert_equal 1, 1
      lambda {
        assert_equal 1, 2
      }.should_raise Test::Unit::AssertionFailedError
    end
  end
end
