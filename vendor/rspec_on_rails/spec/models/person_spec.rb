require File.dirname(__FILE__) + '/../spec_helper'

context "The Person model" do
  fixtures :people, :animals

  setup do
    # fixtures are setup before this
  end

  specify "should find an existing person" do
    person = Person.find(1)

    person.should_equal people(:lachie)
    person.name.should_equal 'Lachie'
  end
  
  specify "should have animals" do
    people(:lachie).should_have(2).animals
  end
  
  teardown do
    # fixtures are torn down after this
  end
end

context "A new Person" do
  fixtures :people
  
  specify "should have no name (this fails because of a conflict with sugar's use of method_missing)" do
    Person.new.name.should_be nil
  end

  specify "should have no name (this passes using dots)" do
    Person.new.name.should.be nil
  end
end