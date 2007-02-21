require File.dirname(__FILE__) + '/spec_helper'

# Run spec w/ -fs to see the output of this file

context "specs with no names" do
  
  #spec name is auto-generated as "should equal(5)"
  specify do
    5.should equal(5)
  end
end