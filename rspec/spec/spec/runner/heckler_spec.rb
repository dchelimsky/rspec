require File.dirname(__FILE__) + '/../../spec_helper.rb'
unless [/mswin/, /java/].detect{|p| p =~ RUBY_PLATFORM}
  require 'spec/runner/heckle_runner'

  describe "Heckler" do
    it "should run behaviour_runner on tests_pass?" do
      options = Spec::Runner::Options.new(StringIO.new, StringIO.new)
      behaviour_runner = Spec::Runner::BehaviourRunner.new(options)
      run = behaviour_runner.method(:run)
      behaviour_runner.should_receive(:run).with(false).and_return(&run)
      heckler = Spec::Runner::Heckler.new('Array', 'push', behaviour_runner)
      heckler.tests_pass?
    end
  end
end
