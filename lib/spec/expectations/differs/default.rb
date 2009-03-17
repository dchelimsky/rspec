begin
  require 'diff/lcs'
rescue LoadError
  if ENV['DONT_MAKE_ME_USE_RUBYGEMS']
    raise <<-MESSAGE

We need to load the diff-lcs gem, but you've set
the DONT_MAKE_ME_USE_RUBYGEMS environment variable 
and failed to supply a means of loading diff-lcs.
MESSAGE
  end
  begin
    require 'rubygems'
    require 'diff/lcs'
  rescue LoadError
    raise "You must gem install diff-lcs to use diffing"
  end
end

require 'diff/lcs/hunk'

require 'pp'

module Spec
  module Expectations
    module Differs

      # TODO add some rdoc
      class Default
        def initialize(options)
          @options = options
        end

        # This is snagged from diff/lcs/ldiff.rb (which is a commandline tool)
        def diff_as_string(data_new, data_old)
          data_old = data_old.split(/\n/).map! { |e| e.chomp }
          data_new = data_new.split(/\n/).map! { |e| e.chomp }
          output = ""
          diffs = Diff::LCS.diff(data_old, data_new)
          return output if diffs.empty?
          oldhunk = hunk = nil  
          file_length_difference = 0
          diffs.each do |piece|
            begin
              hunk = Diff::LCS::Hunk.new(data_old, data_new, piece, context_lines,
                                         file_length_difference)
              file_length_difference = hunk.file_length_difference      
              next unless oldhunk      
              # Hunks may overlap, which is why we need to be careful when our
              # diff includes lines of context. Otherwise, we might print
              # redundant lines.
              if (context_lines > 0) and hunk.overlaps?(oldhunk)
                hunk.unshift(oldhunk)
              else
                output << oldhunk.diff(format)
              end
            ensure
              oldhunk = hunk
              output << "\n"
            end
          end  
          #Handle the last remaining hunk
          output << oldhunk.diff(format) << "\n"
        end  

        def diff_as_object(target,expected)
          diff_as_string(PP.pp(target,""), PP.pp(expected,""))
        end

        protected
        def format
          @options.diff_format
        end

        def context_lines
          @options.context_lines
        end
      end
    end
  end
end
