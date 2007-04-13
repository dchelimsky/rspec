module Spec
  module Runner
    module Formatter
      # This class extracts code snippets by looking at the backtrace of the passed error
      class SnippetExtractor #:nodoc:
        class NullConverter; def convert(code, pre); code; end; end #:nodoc:
        begin; require 'rubygems'; require 'syntax/convertors/html'; @@converter = Syntax::Convertors::HTML.for_syntax "ruby"; rescue LoadError => e; @@converter = NullConverter.new; end
        
        def snippet(error)
          code, line = snippet_for(error.backtrace[0])
          highlighted = @@converter.convert(code, false)
          highlighted == code ? code : post_process(highlighted, line)
        end
        
        def snippet_for(error_line)
          if error_line =~ /(.*):(\d+)/
            file = $1
            line = $2.to_i
            [lines_around(file, line), line]
          else
            ["# Couldn't get snippet for #{error_line}", 1]
          end
        end
        
        def lines_around(file, line)
          if File.file?(file)
            lines = File.open(file).read.split("\n")
            min = [0, line-3].max
            max = [line+1, lines.length-1].min
            selected_lines = []
            selected_lines.join("\n")
            lines[min..max].join("\n")
          else
            "# Couldn't get snippet for #{file}"
          end
        end
        
        def post_process(html, offending_line)
          new_lines = []
          html.split("\n").each_with_index do |line, i|
            new_line = "<span class=\"linenum\">#{offending_line+i-2}</span>#{line}"
            new_line = "<span class=\"offending\">#{new_line}</span>" if i == 2
            new_lines << new_line
          end
          new_lines.join("\n")
        end
        
      end
    end
  end
end