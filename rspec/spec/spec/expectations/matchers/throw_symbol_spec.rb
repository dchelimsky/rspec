require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "proc.should throw_symbol(:sym)" do
  specify "should match if symbol is thrown" do
    throw_symbol.matches?(lambda{ throw :sym }).should be(true)
  end

  specify "should not match if symbol is not thrown" do
    throw_symbol.matches?(lambda{ }).should be(false)
  end
  
  specify "should provide failure message" do
    #given
    proc = lambda {}
    matcher = throw_symbol
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.failure_message.should == "expected a Symbol thrown but nothing was thrown"
  end
  
  specify "should provide negative failure message" do
    #given
    proc = lambda {throw :sym}
    matcher = throw_symbol
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.negative_failure_message.should == "expected no Symbol thrown, got :sym"
  end
end

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
    matcher.failure_message.should == "expected :sym thrown, got :other"
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
