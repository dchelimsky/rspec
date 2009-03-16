module Spec
  module Matchers
    module Pretty
      def split_words(sym)
        sym.to_s.gsub(/_/,' ')
      end

      def to_sentence(words)
        case words.length
          when 0
            ""
          when 1
            " #{words[0]}"
          when 2
            " #{words[0]} and #{words[1]}"
          else
            " #{words[0...-1].join(', ')}, and #{words[-1]}"
        end
      end
    end
  end
end