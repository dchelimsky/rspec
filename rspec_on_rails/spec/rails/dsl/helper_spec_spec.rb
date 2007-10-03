require File.dirname(__FILE__) + '/../../spec_helper'
Spec::Runner.configuration.global_fixtures = :people

describe "HelperExample", :behaviour_type => :helper do
  helper_name :explicit
  
  it "should have direct access to methods defined in helpers" do
    method_in_explicit_helper.should =~ /text from a method/
  end
  
  it "should have access to named routes" do
    rspec_on_rails_specs_url.should == "http://test.host/rspec_on_rails_specs"
    rspec_on_rails_specs_path.should == "/rspec_on_rails_specs"
  end

  it "should fail if the helper method deson't exist" do
    lambda { non_existant_helper_method }.should raise_error(NameError)
  end
end


describe "HelperExample#eval_erb", :behaviour_type => :helper do
  helper_name :explicit
  
  it "should support methods that accept blocks" do
    eval_erb("<% prepend 'foo' do %>bar<% end %>").should == "foobar"
  end
end

describe "HelperExample.fixtures", :behaviour_type => :helper do
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

describe "HelperExample included modules", :behaviour_type => :helper do
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
    ActionView::Helpers::NumberHelper,
    ActionView::Helpers::PrototypeHelper,
    ActionView::Helpers::ScriptaculousHelper,
    ActionView::Helpers::TagHelper,
    ActionView::Helpers::TextHelper,
    ActionView::Helpers::UrlHelper
  ]
  unless ['edge','2.0.0'].include?(ENV['RSPEC_RAILS_VERSION'])
    helpers += [
      ActionView::Helpers::PaginationHelper,
      ActionView::Helpers::JavaScriptMacrosHelper
    ]
  end
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
      describe HelperExample do
        it "should tell you its behaviour_type is :helper" do
          behaviour = Class.new(HelperExample).describe("")
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
