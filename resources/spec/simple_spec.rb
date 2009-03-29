$:.push File.join(File.dirname(__FILE__), *%w[.. .. lib])
require 'spec/autorun'

describe "Running an Example" do
  it "should not output twice" do
    true.should be_true
  end
end