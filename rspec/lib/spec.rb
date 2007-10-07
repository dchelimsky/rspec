require 'spec/version'
require 'spec/matchers'
require 'spec/expectations'
require 'spec/translator'
require 'spec/dsl'
require 'spec/extensions'
require 'spec/runner'
require 'spec/story'
require 'spec/test' if Object.const_defined?(:Test)
at_exit do
  unless Object.const_defined?(:Test); exit rspec_options.run_examples; end
end