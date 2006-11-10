module Spec
  module Runner
    module Formatter
      # Formats backtraces so they're clickable by TextMate
      class TextMateFormatter < HtmlFormatter
        def format_backtrace(backtrace)
          return "" if backtrace.nil?
          backtrace.map do |line| 
            if line =~ /(.*):(\d+)(:in `.*)/
              path = $1
              line = $2
              rest = $3
              href = "txmt://open?url=file://#{File.expand_path(path)}&line=#{line}"
              "<a href=\"#{href}\">#{path}:#{line}</a>#{rest}"
            else
              line
            end
          end.join("\n")
        end
      end
    end
  end
end
