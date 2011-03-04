require 'spec_helper'

class Bug1049Class

    def self.singleton
      @singleton ||= new
    end

    # Redirect all missing class methods to the singleton instance for backwards compatible API
    def self.method_missing(name,*args,&block)
      self.singleton.send(name,*args,&block)
    end

    def bar
      "abc"
    end
end

describe Bug1049Class do

  it "should mock correctly" do
    Bug1049Class.should_receive(:bar).and_return(123)
    Bug1049Class.bar.should == 123
  end

  it "should call successfully after a mock" do
    Bug1049Class.bar.should == "abc"
  end

end