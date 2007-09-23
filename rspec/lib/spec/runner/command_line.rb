require 'spec/runner/option_parser'

module Spec
  module Runner
    # Facade to run specs without having to fork a new ruby process (using `spec ...`)
    class CommandLine
      # Runs specs. +argv+ is the commandline args as per the spec commandline API, +err+
      # and +out+ are the streams output will be written to. +exit+ tells whether or
      # not a system exit should be called after the specs are run.
      def self.run(argv, err, out)
        old_behaviour_runner = defined?($behaviour_runner) ? $behaviour_runner : nil
        begin
          parser = OptionParser.new(err, out)
          parser.order!(argv)
          options = parser.options
          $behaviour_runner = options.create_behaviour_runner
          return true unless $behaviour_runner # This is the case if we use --drb

          options.load_paths
          return $behaviour_runner.run
        ensure
          $behaviour_runner = old_behaviour_runner
        end
      end
    end
  end
end
