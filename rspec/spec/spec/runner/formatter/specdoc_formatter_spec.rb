require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Runner
module Formatter
context "SpecdocFormatter" do
    setup do
        @io = StringIO.new
        @formatter = SpecdocFormatter.new(@io)
      
    end
    specify "should produce standard summary" do
        @formatter.dump_summary(3, 2, 1)
        @io.string.should eql("\nFinished in 3 seconds\n\n2 examples, 1 failure\n")
      
    end
    specify "should push context name" do
        @formatter.add_behaviour("context")
        @io.string.should eql("\ncontext\n")
      
    end
    specify "should push failing spec name and failure number" do
        @formatter.example_failed("spec", 98, Reporter::Failure.new("c s", RuntimeError.new))
        @io.string.should eql("- spec (ERROR - 98)\n")
      
    end
    specify "should push nothing on start" do
        @formatter.start(5)
        @io.string.should eql("")
      
    end
    specify "should push nothing on start dump" do
        @formatter.start_dump
        @io.string.should eql("")
      
    end
    specify "should push passing spec name" do
        @formatter.example_passed("spec")
        @io.string.should eql("- spec\n")
      
    end
  
end
end
end
end