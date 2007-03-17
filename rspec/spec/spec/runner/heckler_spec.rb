require File.dirname(__FILE__) + '/../../spec_helper.rb'
unless ['i386-mswin32', 'java'].index(PLATFORM)
  require 'spec/runner/heckle_runner'

  context "Heckler" do
    specify "should run behaviour_runner on tests_pass?" do
      behaviour_runner = mock("behaviour_runner")
      behaviour_runner.should_receive(:run)
      heckler = Spec::Runner::Heckler.new('Array', 'push', behaviour_runner)

      heckler.tests_pass?
    end
  end
end