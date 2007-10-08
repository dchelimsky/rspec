require 'spec/runner/option_parser'

module Spec
  module Runner
    # Facade to run specs without having to fork a new ruby process (using `spec ...`)
    class CommandLine
      class << self
        # Runs specs. +argv+ is the commandline args as per the spec commandline API, +err+
        # and +out+ are the streams output will be written to.
        def run(instance_rspec_options=rspec_options)
          old_rspec_options = rspec_options
          begin
            $rspec_options = instance_rspec_options
            return true if rspec_options.generate

            rspec_options.load_paths
            success = rspec_options.run_examples
            heckle(rspec_options) if rspec_options.heckle_runner
            return success
          ensure
            $rspec_options = old_rspec_options
          end
        end

        protected
        def heckle(options)
          heckle_runner = options.heckle_runner
          options.heckle_runner = nil
          heckle_runner.heckle_with
        end
      end
    end
  end
end
