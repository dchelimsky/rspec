$:.push File.join(File.dirname(__FILE__), *%w[.. .. .. lib])
require 'spec'

describe Array do
  before(:each) do
    @array = Array.new
  end
  
  describe "when empty" do
    it "should be empty" do
      @array.should be_empty
    end
  end
  
  describe "with one item" do
    before(:each) do
      @array.push Object.new
    end
    
    it "should not be empty" do
      @array.should_not be_empty
    end
  end  
end