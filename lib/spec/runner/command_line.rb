module Spec
  module Runner
    # Facade to run specs
    class CommandLine
      # Runs specs
      def self.run(argv, stderr, stdout, exit, warn_if_no_files)
        old_context_runner = defined?($context_runner) ? $context_runner : nil
        $context_runner = OptionParser.create_context_runner(argv, stderr, stdout, warn_if_no_files)

        # If ARGV is a glob, it will actually each over each one of the matching files.
        argv.each do |file_or_dir|
          if File.directory?(file_or_dir)
            Dir["#{file_or_dir}/**/*.rb"].each do |file| 
              load file
            end
          elsif File.file?(file_or_dir)
            load file_or_dir
          else
            raise "File or directory not found: #{file_or_dir}"
          end
        end
        context_runner.run(exit)
        $context_runner = old_context_runner
      end
    end
  end
end