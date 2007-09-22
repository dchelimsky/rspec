require 'stringio'
require 'rbconfig'
require 'tmpdir'

dir = File.dirname(__FILE__)
lib_path = File.expand_path("#{dir}/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
$_spec_spec = true # Prevents Kernel.exit in various places

require 'spec'
require 'spec/mocks'
spec_classes_path = File.expand_path("#{dir}/../spec/spec/spec_classes")
require spec_classes_path unless $LOAD_PATH.include?(spec_classes_path)
require File.dirname(__FILE__) + '/../lib/spec/expectations/differs/default'

module Spec
  module Matchers
    def fail
      raise_error(Spec::Expectations::ExpectationNotMetError)
    end

    def fail_with(message)
      raise_error(Spec::Expectations::ExpectationNotMetError, message)
    end

    class Pass
      def matches?(proc, &block)
        begin
          proc.call
          true
        rescue Exception => @error
          false
        end
      end

      def failure_message
        @error.message + "\n" + @error.backtrace.join("\n")
      end
    end

    def pass
      Pass.new
    end
  end
end

class NonStandardError < Exception; end

describe "Test::Unit io sink", :shared => true do
  before do
    @test_runner_io = StringIO.new
    Test::Unit::UI::Console::TestRunner.const_set(:STDOUT, @test_runner_io)
  end

  after do
    Test::Unit::UI::Console::TestRunner.__send__(:remove_const, :STDOUT)
  end
end