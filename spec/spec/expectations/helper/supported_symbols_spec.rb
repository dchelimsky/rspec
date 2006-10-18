require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "SupportedSymbols" do
  specify "should not support not equals operator" do
    "!=".to_sym.should_not_be_supported_by_rspec
  end

  specify "should support equals operator" do
    "==".to_sym.should_be_supported_by_rspec
  end

  specify "should support greater than" do
    ">".to_sym.should_be_supported_by_rspec
  end

  specify "should support greater than or equal to" do
    ">=".to_sym.should_be_supported_by_rspec
  end

  specify "should support less than" do
    "<".to_sym.should_be_supported_by_rspec
  end

  specify "should support less than or equal to" do
    "<=".to_sym.should_be_supported_by_rspec
  end

  specify "should support regex match operator" do
    "=~".to_sym.should_be_supported_by_rspec
  end
end
