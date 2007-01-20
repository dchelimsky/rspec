require File.dirname(__FILE__) + '/../spec_helper'

context "The Person model with fixtures loaded" do
  fixtures :people, :animals

  setup do
    # fixtures are setup before this
  end

  specify "should have a non-empty collection of people" do
    Person.find(:all).should_not be(:empty)
  end

  specify "should have one record" do
    Person.should have(1).record
  end

  specify "should find an existing person" do
    person = Person.find(people(:lachie).id)
    person.should eql(people(:lachie))
  end

  specify "should have animals" do
    people(:lachie).should have(2).animals
  end

  specify "should include animals" do
    people(:lachie).should have(2).animals
    people(:lachie).animals.should include(animals(:horse))
  end

  teardown do
    # fixtures are torn down after this
  end
end

context "A new Person with a name" do
  fixtures :people
  
  setup do
    @person = Person.new(:name => "CheliDaveSlak and the Fabulous Baker Boy")
  end

  specify "should be valid" do
    @person.should be(:valid)
  end

  specify "should have no errors after save" do
    @person.save.should_be true
    @person.errors.should be(:empty)
  end
end

context "A person with 2 animals" do
  setup do
    @fluff = Animal.new(:name => "fluff", :age => 7)
    @binki = Animal.new(:name => "binki", :age => 0.5)
    @person = Person.new(:name => "David")
    @person.add_animal(@fluff)
    @person.add_animal(@binki)
  end
  
  specify "should be able to tell you its pups" do
    @person.animals.pups.should == [@binki]
  end
  
  specify "should be able to tell you its adults" do
    @person.animals.adults.should == [@fluff]
  end
end
    