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

  # http://rubyforge.org/tracker/index.php?func=detail&aid=5539&group_id=797&atid=3149
  # specify "should include animals" do
  #  people(:lachie).animals.should_include animals(:horse)
  # end

  teardown do
    # fixtures are torn down after this
  end
end

context "A new Person" do
  fixtures :people

  specify "should have no name" do
    Person.new.name.should_be nil
  end
end