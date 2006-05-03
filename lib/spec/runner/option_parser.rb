require 'ostruct'
require 'optparse'

module Spec
  module Runner
    class OptionParser

      def self.create_context_runner(args, standalone, err, out=STDOUT)
        options = parse(args, standalone, err, out)

        formatter = options.formatter_type.new(options.out)
        reporter = Reporter.new(formatter, options.backtrace_tweaker) 
        ContextRunner.new(reporter, standalone, options.dry_run)
      end

      def self.parse(args, standalone, err, out)
        options = OpenStruct.new
        options.out = out
        options.formatter_type = ProgressBarFormatter
        options.backtrace_tweaker = QuietBacktraceTweaker.new

        opts = ::OptionParser.new do |opts|
          opts.banner = "Usage: spec [options] (FILE|DIRECTORY)+"
          opts.separator ""

          opts.on("-b", "--backtrace", "Output full backtrace") do
            options.backtrace_tweaker = NoisyBacktraceTweaker.new
          end
          
          opts.on("-f", "--format [specdoc|rdoc]", "Output format") do |format|
            options.formatter_type = case(format)
              when 'specdoc' then SpecdocFormatter
              when 'rdoc'    then RdocFormatter
            end
            options.dry_run = true if format == 'rdoc'
          end

          opts.on("-d", "--dry-run", "Don't execute specs") do
            options.dry_run = true
          end

          opts.on("--version", "Show version") do
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