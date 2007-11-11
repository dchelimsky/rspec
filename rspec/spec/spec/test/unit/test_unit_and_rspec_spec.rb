require File.dirname(__FILE__) + '/../../../spec_helper.rb'

describe "Test::Unit interaction" do
  it "runs tests and specs" do
    `ruby #{dir}/sample_spec_test.rb`
    $?.should be_success
  end
  
  it "monkey patches AutoRunner" do
    `ruby #{dir}/autorunner_test.rb`
    $?.should be_success
  end

  it "runs methods beginning with test" do
    behaviour = Class.new(::Spec::DSL::ExampleGroup).describe("Examples") do
      def test_should_have_seamless_transition_from_test_unit
        true.should be_true
      end
    end
    suite = behaviour.suite
    suite.size.should == 1
    suite.run.should be_true
  end

  def dir
    File.dirname(__FILE__)
  end
end
