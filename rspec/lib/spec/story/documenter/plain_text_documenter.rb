module Spec
  module Story
    module Documenter
      class PlainTextDocumenter
        def initialize(out)
          @out = out
        end
        
        def story_started(title, narrative)
          @out << "Story: #{title}\n#{narrative}\n"
        end
        
        def story_ended(title, narrative)
          @out << "\n\n"
        end
        
        def scenario_started(story_title, scenario_name)
          @out << "\nScenario: #{scenario_name}\n"
        end
        
        def found_step(name, description, *args)
          args_txt = args.empty? ? "" : " #{args.join ','}"
          @out << "  #{name.to_s.capitalize} #{description}#{args_txt}\n"
        end
        
        def method_missing(meth, *args, &block)
          # ignore any other calls
        end
      end
    end
  end
end
