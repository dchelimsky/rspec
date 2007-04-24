require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Runner
module Formatter
context "RdocFormatter" do
    setup do
        @io = StringIO.new
        @formatter = RdocFormatter.new(@io)
        @formatter.dry_run = true
    end
    specify "should produce no summary" do
        @formatter.dump_summary(nil, nil, nil)
        @io.string.should be_empty
      
    end
    specify "should produce nothing on start dump" do
        @formatter.start_dump
        @io.string.should be_empty
      
    end
    specify "should push out context" do
        @formatter.add_behaviour("context")
        @io.string.should eql("# context\n")
      
    end
    specify "should push out failed spec" do
        @formatter.example_failed("spec", 98, nil)
        @io.string.should eql("# * spec [98 - FAILED]\n")
      
    end
    specify "should push out spec" do
        @formatter.example_passed("spec")
        @io.string.should eql("# * spec\n")
      
    end
  
end
end
end
end