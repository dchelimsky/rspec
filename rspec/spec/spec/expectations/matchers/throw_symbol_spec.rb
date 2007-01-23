require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "proc.should throw_symbol(:sym)" do
  specify "should match if symbol is thrown" do
    throw_symbol(:sym).matches?(lambda{ throw :sym }).should be(true)
  end

  specify "should not match if no symbol is thrown" do
    throw_symbol(:sym).matches?(lambda{ }).should be(false)
  end

  specify "should not match if wrong symbol is thrown" do
    throw_symbol(:sym).matches?(lambda{ throw :other }).should be(false)
  end
  
  specify "should supply failure_message if no symbol is thrown" do
    #given
    proc = lambda {}
    matcher = throw_symbol(:sym)
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.failure_message.should == "expected :sym thrown but nothing was thrown"
  end
  
  specify "should supply failure_message if wrong symbol is thrown" do
    #given
    proc = lambda { throw :other }
    matcher = throw_symbol(:sym)
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.failure_message.should == "expected :sym thrown, got #<NameError: uncaught throw `other'>"
  end
  
  specify "should supply negative_failure_message if exact symbol is thrown" do
    #given
    proc = lambda { throw :sym }
    matcher = throw_symbol(:sym)
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.negative_failure_message.should == "expected :sym to not be thrown, but it was"
  end
end
