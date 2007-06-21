require File.dirname(__FILE__) + '/../../spec_helper'

module ActionController
  describe "Rescue", "#rescue_action" do
    before do
      @fixture = Object.new
      @fixture.extend ActionController::Rescue
      class << @fixture
        public :rescue_action
      end
    end

    it "raises the passed in exception so examples fail fast" do
      proc {@fixture.rescue_action(RuntimeError.new("Foobar"))}.should raise_error(RuntimeError, "Foobar")
      proc {@fixture.rescue_action(Spec::Mocks::MockExpectationError.new("Foobar"))}.should raise_error(Spec::Mocks::MockExpectationError, "Foobar")
    end
  end
end
