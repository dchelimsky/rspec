module Spec
  module Story
    module Reporter
      class PlainTextReporter
        def initialize(out)
          @out = out
          @succeeded = 0
          @failed = []
          @pending = []
        end
        
        def scenario_succeeded(story_title, scenario_name)
          @out << '.'
          @succeeded += 1
        end
        
        def scenario_failed(story_title, scenario_name, err)
          @out << "FAILED\n"
          @failed << [story_title, scenario_name, err]
        end
        
        def scenario_pending(story_title, scenario_name, msg)
          @pending << [story_title, scenario_name, msg]
          @out << "PENDING\n"
        end
        
        def run_started(count)
          @count = count
          @out << "Running #@count scenarios:\n"
        end
        
        def run_ended
          @out << "\n\n#@count scenarios: #@succeeded succeeded, #{@failed.size} failed, #{@pending.size} pending\n"
          unless @pending.empty?
            @out << "\nPending:\n"
            @pending.each_with_index do |pending, i|
              title, scenario_name, msg = pending
              @out << "#{i+1}) #{title} (#{scenario_name}): #{msg}\n"
            end
          end
          unless @failed.empty?
            @out << "\nFAILURES:"
            @failed.each_with_index do |failure, i|
              title, scenario_name, err = failure
              @out << %[
  #{i+1}) #{title} (#{scenario_name}) FAILED
  #{err.class}: #{err.message}
  #{err.backtrace.join("\n")}
  ]
            end
          end
        end
        
        def method_missing(meth, *args, &block)
          # ignore unexpected callbacks
        end
      end
    end
  end
end
