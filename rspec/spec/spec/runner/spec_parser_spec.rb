require File.dirname(__FILE__) + '/../../spec_helper.rb'

context "c" do

  specify "1" do
  end

  specify "2" do
  end

end

describe "d" do

  it "3" do
  end

  it "4" do
  end

end

class SpecParserSubject
end

describe SpecParserSubject do
  
  it "5" do
  end
  
end

describe SpecParserSubject, " described" do
  
  it "6" do
  end
  
end

context "SpecParser" do
  setup do
    @p = Spec::Runner::SpecParser.new
  end

  specify "should find spec name for 'specify' at same line" do
    @p.spec_name_for(File.open(__FILE__), 5).should_eql "c 1"
  end

  specify "should find spec name for 'specify' at end of spec line" do
    @p.spec_name_for(File.open(__FILE__), 6).should_eql "c 1"
  end

  specify "should find context for 'context' above all specs" do
    @p.spec_name_for(File.open(__FILE__), 4).should_eql "c"
  end

  specify "should find spec name for 'it' at same line" do
    @p.spec_name_for(File.open(__FILE__), 15).should_eql "d 3"
  end

  specify "should find spec name for 'it' at end of spec line" do
    @p.spec_name_for(File.open(__FILE__), 16).should_eql "d 3"
  end

  specify "should find context for 'describe' above all specs" do
    @p.spec_name_for(File.open(__FILE__), 14).should_eql "d"
  end

 # specify "should find context name between specs" do
 #   @p.spec_name_for(File.open(__FILE__), 7).should_eql "c"
 # end

  specify "should find nothing outside a context" do
    @p.spec_name_for(File.open(__FILE__), 2).should_be_nil
  end
  
  specify "should find context name for type" do
    @p.spec_name_for(File.open(__FILE__), 26).should_eql "SpecParserSubject"
  end
  
  specify "should find context and spec name for type" do
    @p.spec_name_for(File.open(__FILE__), 28).should_eql "SpecParserSubject 5"
  end

  specify "should find context and description for type" do
    @p.spec_name_for(File.open(__FILE__), 33).should_eql "SpecParserSubject described"
  end
  
end