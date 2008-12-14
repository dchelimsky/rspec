require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    module ArgumentConstraints
      describe HashNotIncludingConstraint do
        
        it "should describe itself properly" do
          HashNotIncludingConstraint.new(:key1, :key2).description.should == "hash_not_including(:key1, :key2)"
        end      

        describe "passing" do
          it "should match a hash without the specified key" do
            hash_not_including(:c).should == {:a => 1, :b => 2}
          end

          it "should match an empty hash" do
            hash_not_including(:a).should == {}
          end
          
          it "should match a hash without any of the specified keys" do
            hash_not_including(:a, :b, :c).should == { :d => 7}
          end
        end
        
        describe "failing" do
          it "should not match a hash with a specified key" do
            hash_not_including(:b).should_not == {:b => 2}
          end
          
          it "should not match a hash with one of the specified keys" do
            hash_not_including(:a, :b).should_not == {:b => 2}
          end
          
          it "should not match a hash with some of the specified keys" do
            hash_not_including(:a, :b, :c).should_not == {:a => 1, :b => 2}
          end
        end
      end
    end
  end
end
