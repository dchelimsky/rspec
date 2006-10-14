require 'test/unit'
require 'stringio'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'spec'
require File.dirname(__FILE__) + '/../spec/spec/test_classes'
RSPEC_TESTING = true unless defined? RSPEC_TESTING # This causes the diff extension to not be loaded
require 'spec/expectations/diff'
$context_runner ||= ::Spec::Runner::OptionParser.create_context_runner(['test'], false, STDERR, STDOUT)
require 'spec/test_to_spec/sexp_transformer'
require 'spec/test_to_spec/ruby2ruby'

