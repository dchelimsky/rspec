require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      class ProgressBarFormatter < BaseTextFormatter
        def example_failed(example, counter, failure)
          @output.print colorize_failure('F', failure)
          @output.flush
        end

        def example_passed(example)
          @output.print green('.')
          @output.flush
        end
      
        def example_pending(example, message, pending_caller)
          super
          @output.print yellow('*')
          @output.flush
        end
        
        def start_dump
          @output.puts
          @output.flush
        end

        def respond_to?(message, include_private = false)
          if include_private
            true
          else
            !private_methods.include?(message.to_s)
          end
        end

      private
        
        def method_missing(sym, *args)
          # ignore
        end
      end
    end
  end
end
