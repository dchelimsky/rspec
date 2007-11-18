module Spec
  module Story
    module Reporter
      class PlainTextReporter
        def initialize(out)
          @out = out
          @successful_scenario_count = 0
          @pending_scenario_count = 0
          @failed_scenarios = []
          @pending_steps = []
          @previous_type = nil
        end
        
        def run_started(count)
          @count = count
          @out << "Running #@count scenarios:\n\n"
        end
        
        def scenario_started(story_title, scenario_name)
          @scenario_already_failed = false
          @out << "\n\nScenario: #{scenario_name}"
          @scenario_ok = true
        end
        
        def scenario_succeeded(story_title, scenario_name)
          @successful_scenario_count += 1
        end
        
        def scenario_failed(story_title, scenario_name, err)
          @failed_scenarios << [story_title, scenario_name, err] unless @scenario_already_failed
          @scenario_already_failed = true
        end
        
        def scenario_pending(story_title, scenario_name, msg)
          @pending_steps << [story_title, scenario_name, msg]
          @pending_scenario_count += 1 unless @scenario_already_failed
          @scenario_already_failed = true
        end
        
        def run_ended
          @out << "\n\n#@count scenarios: #@successful_scenario_count succeeded, #{@failed_scenarios.size} failed, #@pending_scenario_count pending\n"
          unless @pending_steps.empty?
            @out << "\nPending Steps:\n"
            @pending_steps.each_with_index do |pending, i|
              title, scenario_name, msg = pending
              @out << "#{i+1}) #{title} (#{scenario_name}): #{msg}\n"
            end
          end
          unless @failed_scenarios.empty?
            @out << "\nFAILURES:"
            @failed_scenarios.each_with_index do |failure, i|
              title, scenario_name, err = failure
              @out << %[
  #{i+1}) #{title} (#{scenario_name}) FAILED
  #{err.class}: #{err.message}
  #{err.backtrace.join("\n")}
  ]
            end
          end
        end
        
        def story_started(title, narrative)
          @out << "Story: #{title}\n\n"
          narrative.each_line do |line|
            @out << "  " << line
          end
        end
        
        def step_succeeded(type, description, *args)
          found_step(type, description, *args)
        end
        
        def step_pending(type, description, *args)
          found_step(type, description, *args)
          @out << " (PENDING)"
          @scenario_ok = false
        end
        
        def step_failed(type, description, *args)
          found_step(type, description, *args)
          @scenario_ok ? (@out << " (FAILED)") : (@out << " (SKIPPED)")
          @scenario_ok = false
        end

        def story_ended(title, narrative)
          @out << "\n\n"
        end
        
        def found_step(type, description, *args)
          args_txt = args.empty? ? "" : " #{args.join ','}"
          if type == @previous_type
            @out << "\n  And "
          else
            @out << "\n\n" << "  #{type.to_s.capitalize} "
          end
          @out << "#{description}#{args_txt}"
          if type == :'given scenario'
            @previous_type = :given
          else
            @previous_type = type
          end
        end

        def method_missing(meth, *args, &block)
          # ignore unexpected callbacks
        end
      end
    end
  end
end
