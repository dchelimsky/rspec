module Spec
  module Runner
    # Facade to run specs
    class CommandLine
      # Runs specs
      def self.run(argv, stderr, stdout, exit, warn_if_no_files)
        $context_runner = OptionParser.create_context_runner(argv, stderr, stdout, warn_if_no_files)

        # If ARGV is a glob, it will actually each over each one of the matching files.
        argv.each do |file_or_dir|
          if File.directory?(file_or_dir)
            Dir["#{file_or_dir}/**/*.rb"].each do |file| 
              load file
            end
          else
            load file_or_dir
          end
        end

        $context_runner.run(exit)
      end
    end
  end
end