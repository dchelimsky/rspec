require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Runner
    module Formatter
      describe ProfileFormatter do
        
        before(:each) do
          @io = StringIO.new
          @options = Options.new(StringIO.new, @io)
          @formatter = @options.create_formatter(ProfileFormatter)
        end
        
        it "should print a heading" do
          @formatter.start(0)
          @io.string.should eql("Profiling enabled.\n")
        end
        
        it "should set the current behaviour" do
          @formatter.add_example_group('Test')
          @formatter.instance_variable_get("@behaviour").should == 'Test'
        end
        
        it "should record the current time when starting a new example" do
          now = Time.now
          Time.stub!(:now).and_return(now)
          @formatter.example_started('should foo')
          @formatter.instance_variable_get("@time").should == now
        end
        
        it "should correctly record a passed example" do
          now = Time.now
          Time.stub!(:now).and_return(now)
          @formatter.add_example_group('Test')
          @formatter.example_started('when foo')
          Time.stub!(:now).and_return(now+1)
          @formatter.example_passed('when foo')
          @formatter.instance_variable_get("@examples").should == [['Test', 'when foo', 1.0]]
        end
        
        it "should sort the results in descending order" do
          @formatter.instance_variable_set("@examples", [['a', 'a', 0.1], ['b', 'b', 0.3], ['c', 'c', 0.2]])
          @formatter.start_dump
          @formatter.instance_variable_get("@examples").should == [ ['b', 'b', 0.3], ['c', 'c', 0.2], ['a', 'a', 0.1]]
        end
        
        it "should print the top 10 results" do
          @formatter.instance_variable_set("@time", Time.now)
          
          15.times do 
            @formatter.example_passed('foo')
          end
          
          @io.should_receive(:print).exactly(10)
          @formatter.start_dump
        end
      end
    end
  end
end