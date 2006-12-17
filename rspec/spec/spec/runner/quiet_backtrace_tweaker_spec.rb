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
        @error.set_backtrace(["/lib/spec/"])
        @tweaker.tweak_backtrace(@error, "spec name")
        unless (@error.backtrace.empty?)
          raise("Should have tweaked away '#{element}'")
        end
      end

      specify "should remove bin spec" do
        @error.set_backtrace(["bin/spec:"])
        @tweaker.tweak_backtrace(@error, "spec name")
        @error.backtrace.should_be_empty
      end
      
      specify "should clean up double slashes" do
        @error.set_backtrace(["/a//b/c//d.rb"])
        @tweaker.tweak_backtrace(@error, "spec name")
        @error.backtrace.should_include "/a/b/c/d.rb"
      end
    end
  end
end