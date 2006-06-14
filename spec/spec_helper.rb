require 'test/unit'
require 'stringio'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib'
require 'spec'
$context_runner ||= ::Spec::Runner::OptionParser.create_context_runner(['test'], false, STDERR, STDOUT)
require 'spec/test_to_spec/sexp_transformer'
require 'spec/test_to_spec/ruby2ruby'

