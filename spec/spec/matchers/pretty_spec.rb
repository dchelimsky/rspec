require "spec_helper"

describe Spec::Matchers::Pretty do
  let(:helper) do
    Class.new do
      include Spec::Matchers::Pretty
    end.new
  end
  describe "to_sentence" do
    context "given an empty array" do
      it "returns empty string" do
        helper.to_sentence([]).should == ""
      end
    end

    context "given nil" do
      it "returns empty string" do
        helper.to_sentence.should == ""
      end
    end
  end
end
