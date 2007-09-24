require 'spec/runner/option_parser'

module Spec
  module Runner
    # Facade to run specs without having to fork a new ruby process (using `spec ...`)
    class CommandLine
      class << self
        # Runs specs. +argv+ is the commandline args as per the spec commandline API, +err+
        # and +out+ are the streams output will be written to. +exit+ tells whether or
        # not a system exit should be called after the specs are run.
        def run(argv, err, out)
          old_behaviour_runner = defined?($behaviour_runner) ? $behaviour_runner : nil
          begin
            parser = OptionParser.new(err, out)
            parser.order!(argv)
            options = parser.options
            $behaviour_runner = options.create_behaviour_runner
            return true unless $behaviour_runner # This is the case if we use --drb

            options.load_paths
            success = options.run_examples
            heckle(options) if options.heckle_runner
            
            return success
          ensure
            $behaviour_runner = old_behaviour_runner
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
