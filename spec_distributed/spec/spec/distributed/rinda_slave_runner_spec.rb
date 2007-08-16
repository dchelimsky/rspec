require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Distributed
    describe RindaSlaveRunner do

      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Spec::Runner::Options.new(@err,@out)
      end

      it "should exist" do
        runner = RindaSlaveRunner.new(@options, "args")
      end
      
      it "should handle empty arguments properly" do
        lambda { RindaSlaveRunner.new(@options, ",") }.should raise_error(ArgumentError)
        lambda { RindaSlaveRunner.new(@options, "a,") }.should raise_error(ArgumentError)
        lambda { RindaSlaveRunner.new(@options, ",a") }.should raise_error(ArgumentError)
        lambda { RindaSlaveRunner.new(@options, ",a,") }.should raise_error(ArgumentError)
      end
      
    end
  end
end
