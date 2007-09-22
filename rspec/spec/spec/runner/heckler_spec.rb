require File.dirname(__FILE__) + '/../../spec_helper.rb'
unless [/mswin/, /java/].detect{|p| p =~ RUBY_PLATFORM}
  require 'spec/runner/heckle_runner'

  describe "Heckler" do
    it_should_behave_like "Test::Unit io sink"
    it "should run behaviour_runner on tests_pass?" do
      options = Spec::Runner::Options.new(StringIO.new, StringIO.new)
      runner = Spec::Runner::BehaviourRunner.new(options)
      runner.should_receive(:run).with().and_return(&runner.method(:run))
      heckler = Spec::Runner::Heckler.new('Array', 'push', runner)
      heckler.tests_pass?
    end
  end
end
