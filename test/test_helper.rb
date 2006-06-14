require 'test/unit'
require 'stringio'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.push File.dirname(__FILE__) + '/../test'
require 'spec'
$context_runner = ::Spec::Runner::OptionParser.create_context_runner(['test'], false, STDERR, STDOUT)

# helpers for test_to_spec tests

require 'pp'
require 'stringio'

def verify_sexp_equal(expected, actual)
  unless expected == actual
    raise "expected translation:\n" << my_pp(expected) << "actual translation:\n" << my_pp(actual)
  end
end

def my_pp(*args)
  old_out = $stdout
  begin
    s=StringIO.new
    $stdout=s
    pp(*args)
  ensure
    $stdout=old_out
  end
  s.string
end