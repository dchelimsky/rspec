module Spec
  module Story
    module Documenter
      class PlainTextDocumenter
        def initialize(out)
          @out = out
          @previous_type = nil
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
        
        def found_step(type, description, *args)
          args_txt = args.empty? ? "" : " #{args.join ','}"
          if type == @previous_type
            @out << "  And "
          else
            @out << "\n" << "  #{type.to_s.capitalize} "
          end
          @out << "#{description}#{args_txt}" << "\n"
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
