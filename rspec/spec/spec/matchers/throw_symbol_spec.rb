require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "should throw_symbol" do
  it "should pass if any Symbol is thrown" do
    lambda{ throw :sym }.should throw_symbol
  end

  it "should fail if no Symbol is thrown" do
    lambda {
      lambda { }.should throw_symbol
    }.should fail_with("expected a Symbol but nothing was thrown")
  end
end

describe "should_not throw_symbol" do
  it "should pass if no Symbol is thrown" do
    lambda{ }.should_not throw_symbol
  end

  it "should fail if any Symbol is thrown" do
    lambda {
      lambda { throw :sym }.should_not throw_symbol
    }.should fail_with("expected no Symbol, got :sym")
  end
end

describe "should throw_symbol(:sym)" do
  it "should pass if correct Symbol is thrown" do
    lambda{ throw :sym }.should throw_symbol(:sym)
  end

  it "should fail if no Symbol is thrown" do
    lambda {
      lambda { }.should throw_symbol(:sym)
    }.should fail_with("expected :sym but nothing was thrown")
  end

  it "should fail if wrong Symbol is thrown" do
    lambda {
      lambda { throw :wrong_sym }.should throw_symbol(:sym)
    }.should fail_with("expected :sym, got :wrong_sym")
  end
end

describe "should_not throw_symbol(:sym)" do
  it "should pass if no Symbol is thrown" do
    lambda { }.should_not throw_symbol(:sym)
  end

  it "should pass if other Symbol is thrown" do
    lambda { throw :wrong_sym }.should_not throw_symbol(:sym)
  end

  it "should fail if correct Symbol is thrown" do
    lambda {
      lambda{ throw :sym }.should_not throw_symbol(:sym)
    }.should fail_with("expected :sym not to be thrown")
  end
end
