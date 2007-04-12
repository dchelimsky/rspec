module Spec
  module Runner
    module Formatter
      # This class extracts code snippets by looking at the backtrace of the passed error
      class SnippetExtractor #:nodoc:
        def snippet(error)
          snippet_for(error.backtrace[0])
        end
        
        def snippet_for(error_line)
          if error_line =~ /(.*):(\d+)/
            file = $1
            line = $2.to_i
            lines_around(file, line)
          else
            "# Couldn't get snippet for #{error_line}"
          end
        end
        
        def lines_around(file, line)
          if File.file?(file)
            lines = File.open(file).read.split("\n")
            min = [0, line-3].max
            max = [line+1, lines.length-1].min
            selected_lines = []
            lines[min..max].each_with_index do |line, n|
              selected_lines << "#{n+min+1}: #{line}"
            end
            selected_lines.join("\n")
          else
            "# Couldn't get snippet for #{file}"
          end
        end
      end
    end
  end
end