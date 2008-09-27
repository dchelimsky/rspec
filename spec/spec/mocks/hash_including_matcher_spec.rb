require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    module ArgumentConstraints
      describe HashIncludingConstraint do
      
        it "should match the same hash" do
          hash_including(:a => 1).should == {:a => 1}
        end
      
        it "should not match a non-hash" do
          hash_including(:a => 1).should_not == 1
        end

        it "should match a hash with extra stuff" do
          hash_including(:a => 1).should == {:a => 1, :b => 2}
        end
      
        it "should not match a hash with a missing key" do
          hash_including(:a => 1).should_not == {:b => 2}
        end

        it "should not match a hash with an incorrect value" do
          hash_including(:a => 1, :b => 2).should_not == {:a => 1, :b => 3}
        end

        it "should describe itself properly" do
          HashIncludingConstraint.new(:a => 1).description.should == "hash_including(:a=>1)"
        end      
      end
    end
  end
end
