require File.dirname(__FILE__) + '/../spec_helper'

class Stubbed; end

describe NaughtyController do
  it "should raise mock errors instead of printing them to the response" do
    Stubbed.should_receive(:hello) do |who| 
      who.should == :david # Won't happen
    end

    lambda do
      get 'says_hello_to_aslak'
    end.should raise_error(Spec::Mocks::MockExpectationError)
  end

  it "should print all other errors to the response" do
    lambda do
      get 'raises_regular_error'
    end.should raise_error(RuntimeError, "Naughty!")
  end
end