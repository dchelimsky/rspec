require 'test/unit'
require 'stringio'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../test' # Needed to get access to test (fixture) classes
require 'spec'
require 'test_classes'
$context_runner ||= ::Spec::Runner::OptionParser.create_context_runner(['test'], false, STDERR, STDOUT)
require 'spec/test_to_spec/sexp_transformer'
require 'spec/test_to_spec/ruby2ruby'

