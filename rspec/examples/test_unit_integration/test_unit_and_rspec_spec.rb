$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "..", "lib")

require 'test/unit'
require 'spec/test_case_adapter'

describe "Test::Unit interaction" do
  include RubyRunner
  
  it "runs tests and specs" do
    ruby "#{dir}/sample_spec_test.rb"
    $?.should be_success
  end
  
  it "monkey patches AutoRunner" do
    ruby "#{dir}/autorunner_test.rb"
    $?.should be_success
  end

  def dir
    File.dirname(__FILE__)
  end
end
