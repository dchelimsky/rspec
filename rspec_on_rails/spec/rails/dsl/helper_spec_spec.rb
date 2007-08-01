require File.dirname(__FILE__) + '/../../spec_helper'
Spec::Runner.configuration.global_fixtures = :people

describe "HelperBehaviour", :behaviour_type => :helper do
  helper_name :explicit
  
  it "should have direct access to methods defined in helpers" do
    method_in_explicit_helper.should =~ /text from a method/
  end
end


describe "HelperBehaviour#eval_erb", :behaviour_type => :helper do
  helper_name :explicit
  
  it "should support methods that accept blocks" do
    eval_erb("<% prepend 'foo' do %>bar<% end %>").should == "foobar"
  end
end

describe "HelperBehaviour.fixtures", :behaviour_type => :helper do
  helper_name :explicit
  fixtures :animals

  it "loads fixtures" do
    pig = animals(:pig)
    pig.class.should == Animal
  end

  it "loads global fixtures" do
    lachie = people(:lachie)
    lachie.class.should == Person
  end  
end

describe "HelperBehaviour included modules", :behaviour_type => :helper do
  helpers = [
    ActionView::Helpers::ActiveRecordHelper,
    ActionView::Helpers::AssetTagHelper,
    ActionView::Helpers::BenchmarkHelper,
    ActionView::Helpers::CacheHelper,
    ActionView::Helpers::CaptureHelper,
    ActionView::Helpers::DateHelper,
    ActionView::Helpers::DebugHelper,
    ActionView::Helpers::FormHelper,
    ActionView::Helpers::FormOptionsHelper,
    ActionView::Helpers::FormTagHelper,
    ActionView::Helpers::JavaScriptHelper,
    ActionView::Helpers::JavaScriptMacrosHelper,
    ActionView::Helpers::NumberHelper,
    ActionView::Helpers::PrototypeHelper,
    ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods,
    ActionView::Helpers::ScriptaculousHelper,
    ActionView::Helpers::TagHelper,
    ActionView::Helpers::TextHelper,
    ActionView::Helpers::UrlHelper
  ]
  helpers << ActionView::Helpers::PaginationHelper unless ENV['RSPEC_RAILS_VERSION'] == 'edge'
  helpers.each do |helper_module|
    it "should include #{helper_module}" do
      self.class.ancestors.should include(helper_module)
    end
  end
end

describe ExplicitHelper, :behaviour_type => :helper do
  it "should not require naming the helper if describe is passed a type" do
    method_in_explicit_helper.should match(/text from a method/)
  end
end

module Spec
  module Rails
    module DSL
      describe HelperBehaviour do
        it "should tell you its behaviour_type is :helper" do
          behaviour = HelperBehaviour.new("") {}
          behaviour.behaviour_type.should == :helper
        end
      end
    end
  end
end

module Bug11223
  # see http://rubyforge.org/tracker/index.php?func=detail&aid=11223&group_id=797&atid=3149
  describe 'Accessing flash from helper spec', :behaviour_type => :helper do
    it 'should not raise an error' do
      lambda { flash['test'] }.should_not raise_error
    end
  end
end
