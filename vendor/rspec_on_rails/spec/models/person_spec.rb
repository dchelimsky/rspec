require File.dirname(__FILE__) + '/../spec_helper'

context "The Person model" do
  fixtures :people, :animals

  setup do
    # fixtures are setup before this
  end

  specify "should have a non-empty collection of people" do
    Person.find(:all).should_not_be_empty
  end

  specify "should have one record" do
    Person.should_have(1).records
  end

  specify "should find an existing person" do
    person = Person.find(1)
    person.should_eql people(:lachie)
  end

  specify "should have animals" do
    people(:lachie).should_have(2).animals
  end

  specify "should include animals" do
    people(:lachie).should_have(2).animals
    people(:lachie).animals.should_include animals(:horse)
  end

  teardown do
    # fixtures are torn down after this
  end
end

context "A new Person" do
  fixtures :people
  
  setup do
    @person = Person.new
  end

  specify "should have no name" do
    @person.name.should_be nil
  end
  
  specify "should validate presence of name" do
    @person.save.should_be false
    @person.errors.should_include ["name", "can't be blank"]
  end
  
  specify "should be valid for save if includes a name" do
    @person.name = "CheliDaveSlak and the Fabulous Baker Boy"
    @person.save.should_be true
    @person.errors.should_be_empty
  end
end