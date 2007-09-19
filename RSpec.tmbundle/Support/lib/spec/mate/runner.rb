module Spec
  module Mate
    class Runner
      def run_files(stdout, options={})
        files = ENV['TM_SELECTED_FILES'].split(" ").map{|p| p[1..-2]}
        options.merge!({:files => files})
        run(stdout, options)
      end

      def run_file(stdout, options={})
        options.merge!({:files => [single_file]})
        run(stdout, options)
      end

      def run_focussed(stdout, options={})
        options.merge!({:files => [single_file], :line => ENV['TM_LINE_NUMBER']})
        run(stdout, options)
      end

      def single_file
        ENV['TM_FILEPATH'][ENV['TM_PROJECT_DIRECTORY'].length+1..-1]
      end

      def run(stdout, options)
        argv = options[:files].dup
        argv << '--format'
        argv << 'Spec::Mate::TextMateFormatter'
        if options[:line]
          argv << '--line'
          argv << options[:line]
        end
        argv += ENV['TM_RSPEC_OPTS'].split(" ") if ENV['TM_RSPEC_OPTS']
        Dir.chdir(ENV['TM_PROJECT_DIRECTORY']) do
          ::Spec::Runner::CommandLine.run(argv, STDERR, stdout, false, true)
        end
      end
    end
  end
end