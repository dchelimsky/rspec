$:.unshift File.join(File.dirname(__FILE__), *%w[.. .. .. lib])
require 'spec'

Spec::Runner.configure do |config|
  config.before(:suite) do
    puts "defined in before suite"
  end
  config.before(:each) do
    puts "defined in before each"
  end
  config.before(:all) do
    puts "defined in before all"
  end
end

describe "anything" do
  it "should do anything" do
  end
end