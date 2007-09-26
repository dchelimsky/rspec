require 'spec/runner/option_parser'

module Spec
  module Runner
    # Facade to run specs without having to fork a new ruby process (using `spec ...`)
    class CommandLine
      class << self
        # Runs specs. +argv+ is the commandline args as per the spec commandline API, +err+
        # and +out+ are the streams output will be written to.
        def run(argv, err, out)
          old_rspec_options = defined?($rspec_options) ? $rspec_options : nil
          begin
            parser = OptionParser.new(err, out)
            parser.order!(argv)
            options = parser.options
            $rspec_options = options
            return true if $rspec_options.generate

            options.load_paths
            success = options.run_examples
            heckle(options) if options.heckle_runner

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
