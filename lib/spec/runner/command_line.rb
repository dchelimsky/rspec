require 'spec/runner/option_parser'

module Spec
  module Runner
    # Facade to run specs without having to fork a new ruby process (using `spec ...`)
    class CommandLine
      class << self
        # Runs examples.
        def run(instance_rspec_options=Spec::Runner.options)
          instance_rspec_options.run_examples
        end
      end
    end
  end
end
