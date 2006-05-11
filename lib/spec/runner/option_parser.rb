require 'ostruct'
require 'optparse'

module Spec
  module Runner
    class OptionParser

      def self.create_context_runner(args, standalone, err, out=STDOUT)
        options = parse(args, standalone, err, out)

        formatter = options.formatter_type.new(options.out, options.dry_run)
        reporter = Reporter.new(formatter, options.backtrace_tweaker) 
        ContextRunner.new(reporter, standalone, options.dry_run, options.spec_name)
      end

      def self.parse(args, standalone, err, out)
        options = OpenStruct.new
        options.out = out
        options.formatter_type = ProgressBarFormatter
        options.backtrace_tweaker = QuietBacktraceTweaker.new
        options.spec_name = nil

        opts = ::OptionParser.new do |opts|
          opts.banner = "Usage: spec [options] (FILE|DIRECTORY)+"
          opts.separator ""

          opts.on("-b", "--backtrace", "Output full backtrace") do
            options.backtrace_tweaker = NoisyBacktraceTweaker.new
          end
          
          opts.on("-f", "--format FORMAT", "Output format (specdoc|s|rdoc|r)") do |format|
            options.formatter_type = SpecdocFormatter if format == 'specdoc'
            options.formatter_type = SpecdocFormatter if format == 's'
            options.formatter_type = RdocFormatter if format == 'rdoc'
            options.formatter_type = RdocFormatter if format == 'r'
            options.dry_run = true if format == 'rdoc'
          end

          opts.on("-d", "--dry-run", "Don't execute specs") do
            options.dry_run = true
          end
          
          opts.on("-s", "--spec SPECIFICATION_NAME", "Execute a single specification") do |spec_name|
            options.spec_name = spec_name
          end

          opts.on("-v", "--version", "Show version") do
            out.puts ::Spec::VERSION::DESCRIPTION
            exit if out == $stdout
          end

          opts.on_tail("-h", "--help", "Show this message") do
            out.puts opts
            exit if out == $stdout
          end
          
        end
        opts.parse!(args)

        if args.empty?
          err.puts opts unless standalone
          exit if err == $stderr unless standalone
        end

        options
      end
    end
  end
end