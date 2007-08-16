require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Distributed
    describe RindaMasterRunner do

      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Spec::Runner::Options.new(@err,@out)
      end

      it "should exist" do
        runner = RindaMasterRunner.new(@options, "args")
      end
      
      it "should handle empty arguments properly" do
        lambda { RindaMasterRunner.new(@options, ",") }.should raise_error(ArgumentError)
        lambda { RindaMasterRunner.new(@options, "a,") }.should raise_error(ArgumentError)
        lambda { RindaMasterRunner.new(@options, ",a") }.should raise_error(ArgumentError)
        lambda { RindaMasterRunner.new(@options, ",a,") }.should raise_error(ArgumentError)
      end
      
    end
  end
end
