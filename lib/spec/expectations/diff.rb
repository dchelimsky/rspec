begin
  require 'rubygems'
  require 'diff/lcs' #necessary due to loading bug on some machines - not sure why - DaC
  require 'diff/lcs/hunk'
rescue LoadError ; raise "You must gem install diff-lcs to use diffing" ; end

require 'pp'

module Spec
  module Expectations
    module Should
      class Base
        unless defined?(RSPEC_TESTING)
          alias old_default_message default_message
          def default_message(expectation, expected=:no_expectation_specified)
            result = old_default_message(expectation, expected)
            if expected != :no_expectation_specified
              if expected.is_a?(String)
                result << "\nDiff:" << diff_as_string(@target.to_s, expected)
              elsif ! @target.is_a? Proc
                result << "\nDiff:" << diff_as_object(@target,expected)
              end
            end
            result
          end
        end

        # This is snagged from diff/lcs/ldiff.rb (which is a commandline tool)
        def diff_as_string(data_old, data_new, format=:unified, context_lines=3)
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

        def diff_as_object(target,expected,format=:unified,context_lines=3)
          diff_as_string(PP.pp(target,""), PP.pp(expected,""), format, context_lines)
        end

      end
    end
  end
end
