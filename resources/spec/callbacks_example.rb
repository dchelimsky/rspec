$:.push File.dirname(__FILE__) + "/../../lib"
require 'spec'

Spec::Runner.configure do |c|
  c.before(:suite) do
    puts "before suite"
  end
  c.after(:suite) do
    puts "after suite"
  end
end

describe "before and after callbacks" do
  before(:all) do
    puts "before all"
  end
  
  before(:each) do
    puts "before each"
  end
  
  after(:each) do
    puts "after each"
  end
  
  after(:all) do
    puts "after all"
  end
  
  it "gets run in order" do
    
  end
end