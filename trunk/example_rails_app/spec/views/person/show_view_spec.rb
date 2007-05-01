require File.dirname(__FILE__) + '/../../spec_helper'
require 'ostruct'

describe "/people/show" do
  
  it "should display the person's pets" do
    person = mock("person")
    person.should_receive(:pets).and_return([OpenStruct.new(:name => 'Hannibal'), OpenStruct.new(:name => 'Rufus')])

    assigns[:person] = person
    render "/people/show"
    response.should have_tag('ul') do |tags|
      with_tag('li', 'Hannibal')
      with_tag('li', 'Rufus')
      without_tag('li', 'Ali G')
    end
  end

end