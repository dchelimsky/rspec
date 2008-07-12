require 'spec/runner/option_parser'

module Spec
  module Runner
    class CommandLine
      class << self
        def run(instance_rspec_options=Spec::Runner.options)
          instance_rspec_options.run_examples
        end
      end
    end
  end
end
