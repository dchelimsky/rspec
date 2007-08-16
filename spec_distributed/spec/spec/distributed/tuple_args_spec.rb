require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Distributed
    describe TupleArgs do

      def runner(args)
        Class.new do
          include TupleArgs
          def initialize(options=nil, args=nil)
            process_tuple_args(args)
          end
        end.new("", args)
      end

      it "should create the default tuplespace when no args are given" do
        runner(nil).tuples.should ==  [:rspec_slave, nil, nil]
      end

      it "should add one element to the tuple when one argument is given" do
        runner("One").tuples.should ==  [:rspec_slave, nil, nil, "One"]
      end

      it "should add two elements to the tuple when two arguments are given" do
        runner("One,Two").tuples.should ==  [:rspec_slave, nil, nil, "One", "Two"]
      end

      it "should turn wildcards to 'nil' in the tuplespace" do
        runner("*").tuples.should ==  [:rspec_slave, nil, nil, nil]
        runner("One,*").tuples.should ==  [:rspec_slave, nil, nil, "One", nil]
        runner("*,Two").tuples.should ==  [:rspec_slave, nil, nil, nil, "Two"]
        runner("*,*").tuples.should ==  [:rspec_slave, nil, nil, nil, nil]
      end
    end
  end
end
