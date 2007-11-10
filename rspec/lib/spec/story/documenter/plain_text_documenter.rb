module Spec
  module Story
    module Documenter
      class PlainTextDocumenter
        def initialize(out)
          @out = out
          @previous_type = nil
        end
        
        def story_started(title, narrative)
          @out << "Story: #{title}\n\n"
          narrative.each_line do |line|
            @out << "  " << line
          end
        end
        
        def scenario_started(story_title, scenario_name)
          @out << "\n\nScenario: #{scenario_name}"
          @scenario_ok = true
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
          # ignore any other calls
        end
      end
    end
  end
end
