require File.dirname(__FILE__) + '/../../../lib/spec/mate/switch_command'

module Spec
  module Mate
    class Twin
      def initialize(expected, rails)
        @expected = expected
        @rails = rails
      end

      def matches?(actual)
        @actual = actual
        # Satisfy expectation here. Return false or raise an error if it's not met.
        command = SwitchCommand.new
        command.stub!(:rails?).and_return(@rails)

        path = command.twin(@actual)
        path.should == @expected

        path = command.twin(@expected)
        path.should == @actual
        true
      end

      def failure_message
        "expected #{@actual.inspect} to twin #{@expected.inspect}, but it didn't"
      end

      def negative_failure_message
        "expected #{@actual.inspect} not to twin #{@expected.inspect}, but it did"
      end
      
      def description
        "twin #{@actual} <=> #{@expected}"
      end
    end
    
    class BeA
      def initialize(expected)
        @expected = expected
      end

      def matches?(actual)
        @actual = actual
        c = SwitchCommand.new
        c.stub!(:rails?).and_return(@rails)
        c.file_type(@actual).should == @expected
        true
      end

      def failure_message
        "expected #{@actual.inspect} to be_a #{@expected.inspect}, but it didn't"
      end

      def negative_failure_message
        "expected #{@actual.inspect} not to be_a #{@expected.inspect}, but it did"
      end
    end

    def be_a(expected)
      BeA.new(expected)
    end

    describe SwitchCommand, "in a regular app" do
      include Spec::Mate
      def twin(expected)
        Twin.new(expected, false)
      end

      it do
        "/Users/aslakhellesoy/scm/rspec/trunk/RSpec.tmbundle/Support/spec/spec/mate/switch_command_spec.rb".should twin(
        "/Users/aslakhellesoy/scm/rspec/trunk/RSpec.tmbundle/Support/lib/spec/mate/switch_command.rb")
      end

      it "should suggest plain spec" do
        "/a/full/path/spec/snoopy/mooky_spec.rb".should be_a("spec")
      end

      it "should suggest plain file" do
        "/a/full/path/lib/snoopy/mooky.rb".should be_a("file")
      end
      
      it "should create spec for spec files" do
        regular_spec = <<-SPEC
require File.dirname(__FILE__) + '/../spec_helper'

describe ${1:Type} do
  it "should ${2:description}" do
    $0
  end
end
SPEC
        SwitchCommand.new.content_for('spec', "spec/foo/zap_spec.rb").should == regular_spec
        SwitchCommand.new.content_for('spec', "spec/controller/zap_spec.rb").should == regular_spec
      end

      it "should create class for regular file" do
        file = <<-EOF
module Foo
  class Zap
  end
end
EOF
        SwitchCommand.new.content_for('file', "lib/foo/zap.rb").should == file
        SwitchCommand.new.content_for('file', "some/other/path/lib/foo/zap.rb").should == file
      end
    end

    describe SwitchCommand, "in a Rails app" do
      include Spec::Mate
      def twin(expected)
        Twin.new(expected, true)
      end

      it do
        "/a/full/path/app/controllers/mooky_controller.rb".should twin(
        "/a/full/path/spec/controllers/mooky_controller_spec.rb")
      end

      it do
        "/a/full/path/app/models/mooky.rb".should twin(
        "/a/full/path/spec/models/mooky_spec.rb")
      end

      it do
        "/a/full/path/app/helpers/mooky_helper.rb".should twin(
        "/a/full/path/spec/helpers/mooky_helper_spec.rb")
      end

      it do
        "/a/full/path/app/views/mooky/show.html.erb".should twin(
        "/a/full/path/spec/views/mooky/show.html.erb_spec.rb")
      end
      
      it do
        "/a/full/path/app/views/mooky/show.rhtml".should twin(
        "/a/full/path/spec/views/mooky/show.rhtml_spec.rb")
      end
      
      it "should work with lib dir in rails" do
        "/a/full/path/lib/foo/mooky.rb".should twin(
        "/a/full/path/spec/lib/foo/mooky_spec.rb")
      end
      
      it "should suggest controller spec" do
        "/a/full/path/spec/controllers/mooky_controller_spec.rb".should be_a("controller spec")
      end

      it "should suggest model spec" do
        "/a/full/path/spec/models/mooky_spec.rb".should be_a("model spec")
      end

      it "should suggest helper spec" do
        "/a/full/path/spec/helpers/mooky_helper_spec.rb".should be_a("helper spec")
      end

      it "should suggest view spec" do
        "/a/full/path/spec/views/mooky/show.html.erb_spec.rb".should be_a("view spec")
      end

      it "should suggest controller" do
        "/a/full/path/app/controllers/mooky_controller.rb".should be_a("controller")
      end

      it "should suggest model" do
        "/a/full/path/app/models/mooky.rb".should be_a("model")
      end

      it "should suggest helper" do
        "/a/full/path/app/helpers/mooky_helper.rb".should be_a("helper")
      end

      it "should suggest view" do
        "/a/full/path/app/views/mooky/show.html.erb".should be_a("view")
      end

      it "should create spec that requires a helper" do
        SwitchCommand.new.content_for('controller spec', "spec/controllers/mooky_controller_spec.rb").split("\n")[0].should == 
          "require File.dirname(__FILE__) + '/../spec_helper'"
      end
    end
  end
end
