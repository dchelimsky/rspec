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
          @succeeded += 1
        end
        
        def scenario_started(story_title, scenario_name)
          @scenario_already_failed = false
        end
        
        def scenario_failed(story_title, scenario_name, err)
          @failed << [story_title, scenario_name, err] unless @scenario_already_failed
          @scenario_already_failed = true
        end
        
        def scenario_pending(story_title, scenario_name, msg)
          @pending << [story_title, scenario_name, msg]
        end
        
        def run_started(count)
          @count = count
          @out << "Running #@count scenarios:\n\n"
        end
        
        def run_ended
          @out << "\n\n#@count scenarios: #@succeeded succeeded, #{@failed.size} failed\n"
          unless @pending.empty?
            @out << "\nPENDING:\n"
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
