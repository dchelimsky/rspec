require File.dirname(__FILE__) + '/../spec_helper'

context "The Person model" do
  fixtures :people

  setup do
    # fixtures are setup before this
  end

  specify "should find an existing person" do
    person = Person.find(1)

    person.should_equal people(:lachie)
    person.name.should_equal 'Lachie'
  end

  teardown do
    # fixtures are torn down after this
  end
end
