require File.dirname(__FILE__) + '/../../../spec_helper'
require 'spec/ui/watir/matchers'

class BrowserStub
  def label(*args)
    LabelStub.new(*args)
  end
end

class LabelStub
  def initialize(how, what)
    @how, @what = how, what
  end
  
  def exists?
    @what
  end
end

describe "Browser" do
  include Spec::Matchers::Watir

  before do
    @b = BrowserStub.new
  end
  
  it "should support should have_label" do
    lambda do
      @b.should have_label(:foo, false)
    end.should raise_error(Spec::Expectations::ExpectationNotMetError, 
      'Expected BrowserStub to have label(:foo, false), but it was not found')
  end

  it "should support should_not have_label" do
    lambda do
      @b.should_not have_label(:foo, true)
    end.should raise_error(Spec::Expectations::ExpectationNotMetError, 
      'Expected BrowserStub to not have label(:foo, true), but it was found')
  end
end
