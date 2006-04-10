require 'ostruct'
require 'optparse'
module Spec
  module Runner
    class OptionParser

      def self.parse(args, standalone=false, err=$stderr, out=$stdout)
        options = OpenStruct.new
        options.out = out
        options.verbose = false
        options.doc = false

        opts = ::OptionParser.new do |opts|
          opts.banner = "Usage: spec [options] (FILE|DIRECTORY)+"
          opts.separator ""

          opts.on("-o", "--of [FILE]", "Set the output file (defaults to STDOUT)") do |outfile|
            options.out = outfile unless outfile.nil?
            exit if outfile.nil?
          end

          opts.on("-v", "--verbose", "Verbose output") do
            options.verbose = true
          end

          opts.on("-d", "--doc", "Output specdoc only") do
            options.doc = true
          end

          opts.on("--version", "Show version") do
            out.puts ::Spec::VERSION::DESCRIPTION
            exit if out == $stdout
          end

          opts.on_tail("-h", "--help", "Show this message") do
            err.puts opts
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