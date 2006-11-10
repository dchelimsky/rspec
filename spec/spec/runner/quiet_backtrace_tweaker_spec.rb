require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    context "QuietBacktraceTweaker" do
      setup do
        @error = RuntimeError.new
        @tweaker = QuietBacktraceTweaker.new
      end

      specify "should not barf on nil backtrace" do
        lambda do
          @tweaker.tweak_backtrace(@error, "spec name")
        end.should_not_raise
      end

      specify "should remove anything from rspec on rails" do
        @error.set_backtrace(["/usr/local/lib/ruby/gems/1.8/gems/rspec_generator-0.5.12/lib/rspec_on_rails.rb:33:in `run'"])
        @tweaker.tweak_backtrace(@error, "spec name")
        @error.backtrace.should_be_empty
      end

      specify "should remove anything from textmate ruby bundle" do
        @error.set_backtrace(["/Applications/TextMate.app/Contents/SharedSupport/Bundles/Ruby.tmbundle/Support/tmruby.rb:147"])
        @tweaker.tweak_backtrace(@error, "spec name")
        @error.backtrace.should_be_empty
      end

      specify "should remove anything in lib spec dir" do
        element=
        element=nil
        ["expectations", "mocks", "runner"].each do |child|
          element="/lib/spec/#{child}/anything.rb"
          @error.set_backtrace([element])
          @tweaker.tweak_backtrace(@error, "spec name")
          unless (@error.backtrace.empty?)
            raise("Should have tweaked away '#{element}'")
          end
        end
      end

      specify "should remove bin spec" do
        @error.set_backtrace(["bin/spec:"])
        @tweaker.tweak_backtrace(@error, "spec name")
        @error.backtrace.should_be_empty
      end

      specify "should remove instance exec" do
        @error.set_backtrace(["./examples/airport_spec.rb:28:in `__instance_exec_1014688_1661744'"])
        @tweaker.tweak_backtrace(@error, "spec name")
        @error.backtrace[0].should_eql("./examples/airport_spec.rb:28")
      end
    end
  end
end