require 'spec'

Spec::Configuration.configure do |config|
  config.before(:suite) do
    puts "defined in before suite"
  end
end

describe "anything" do
  it "should do anything" do
  end
end