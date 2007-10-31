require File.dirname(__FILE__) + '/spec_helper.rb'

module Test
  module Unit
    describe AutoRunner, "#process_args" do
      it "should always return true" do
        runner = AutoRunner.new(true)
        runner.process_args(['-b']).should be_true
      end
    end
  end
end