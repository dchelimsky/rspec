require File.dirname(__FILE__) + '/../spec_helper'

describe "The Person model with fixtures loaded" do
  fixtures :people, :animals

  setup do
    # fixtures are setup before this
  end

  it "should have a non-empty collection of people" do
    Person.find(:all).should_not be_empty
  end

  it "should have one record" do
    Person.should have(1).record
  end

  it "should find an existing person" do
    person = Person.find(people(:lachie).id)
    person.should eql(people(:lachie))
  end

  it "should have animals" do
    people(:lachie).should have(2).animals
  end

  it "should include animals" do
    people(:lachie).should have(2).animals
    people(:lachie).animals.should include(animals(:horse))
    people(:lachie).animals.should_not include(Animal.new(:name=>'monkey'))
  end

  teardown do
    # fixtures are torn down after this
  end
end

describe "A new Person with a name" do
  fixtures :people
  
  setup do
    @person = Person.new(:name => "CheliDaveSlak and the Fabulous Baker Boy")
  end

  it "should be valid" do
    @person.should be_valid
  end

  it "should have no errors after save" do
    @person.save.should be_true
    @person.errors.should be_empty
  end
end

describe "A person with 2 animals" do
  setup do
    @fluff = Animal.new(:name => "fluff", :age => 7)
    @binki = Animal.new(:name => "binki", :age => 0.5)
    @person = Person.new(:name => "David")
    @person.add_animal(@fluff)
    @person.add_animal(@binki)
  end
  
  it "should be able to tell you its pups" do
    @person.animals.pups.should == [@binki]
  end
  
  it "should be able to tell you its adults" do
    @person.animals.adults.should == [@fluff]
  end
end
    