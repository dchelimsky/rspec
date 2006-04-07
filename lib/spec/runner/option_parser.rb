require 'ostruct'
require 'optparse'
module Spec
  module Runner
    class OptionParser

      def self.parse(args, standalone=false, err=$stderr)
        options = OpenStruct.new
        options.out = $stdout
        options.verbose = false;
        options.doc = false;

        opts = ::OptionParser.new do |opts|
          opts.banner = "Usage: spec [options] (FILE|DIRECTORY)+"
          opts.separator ""

          opts.on("-o", "--of [FILE]", "Set the output file (defaults to STDOUT)") do |outfile|
            options.out = outfile unless outfile.nil?
            exit if outfile.nil?
          end

          opts.on("-v", "--verbose") do
            options.verbose = true
          end

          opts.on("-d", "--doc", "Generate documentation") do
            options.doc = true
          end

          opts.on_tail("-h", "--help", "Show this message") do
            err.puts opts
            exit if err == $stderr
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