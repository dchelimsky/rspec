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
          opts.banner = "Usage: spec [options] (FILE|DIRECTORY|GLOB)+"
          opts.separator ""

          opts.on("-b", "--backtrace", "Output full backtrace") do
            options.backtrace_tweaker = NoisyBacktraceTweaker.new
          end
          
          opts.on("-r", "--require FILE", "Require FILE before running specs",
                                          "Useful for loading custom formatters or other extensions") do |req|
            require req
          end
          
          opts.on("-f", "--format FORMAT", "Builtin formats: specdoc|s|rdoc|r", 
                                           "You can also specify a custom formatter class") do |format|
            case format
              when 'specdoc', 's'
                options.formatter_type = SpecdocFormatter
              when 'rdoc', 'r'
                options.formatter_type = RdocFormatter
                options.dry_run = true
            else
              begin
                options.formatter_type = eval(format)
              rescue NameError
                err.puts "Couldn't find formatter class #{format}"
                err.puts "Make sure the --require option is specified *before* --format"
                exit if out == $stdout
              end
            end
          end

          opts.on("-d", "--dry-run", "Don't execute specs") do
            options.dry_run = true
          end
          
          opts.on("--diff", "Show unified diff of Strings that are expected to be equal when they are not") do
            require 'spec/api/helper/diff'
          end
          
          opts.on("-s", "--spec SPECIFICATION_NAME", "Execute a single specification") do |spec_name|
            options.spec_name = spec_name
          end

          opts.on("-v", "--version", "Show version") do
            out.puts ::Spec::VERSION::DESCRIPTION
            exit if out == $stdout
          end

          opts.on_tail("-h", "--help", "You're looking at it") do
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