module Spec
  module Example
    def self.args_and_options(*args)
      with_options_from(args) do |options|
        return args, options
      end
    end

    def self.scope_from(*args)
      args[0] || :each
    end

    def self.scope_and_options(*args)
      args, options = args_and_options(*args)
      return scope_from(*args), options
    end

  private
    
    def self.with_options_from(args)
      yield Hash === args.last ? args.pop : {} if block_given?
    end
  end
end

require 'timeout'
require 'spec/example/before_and_after_hooks'
require 'spec/example/pending'
require 'spec/example/module_reopening_fix'
require 'spec/example/example_group_methods'
require 'spec/example/example_methods'
require 'spec/example/example_group'
require 'spec/example/shared_example_group'
require 'spec/example/example_group_factory'
require 'spec/example/errors'
require 'spec/example/configuration'
require 'spec/example/example_matcher'

