# This is the beginning of an experimental StoryParser based on conversations
# on the rspec list: http://rubyforge.org/pipermail/rspec-users/2007-October/003704.html

module Spec
  module Story
    module Runner

      class StoryParser
        attr_reader :story_part_factory
        def initialize(story_part_factory)
          @story_part_factory = story_part_factory
          @current_story_lines = []
          init_states
          transition_to_state(:starting)
        end
        
        def init_states
          @states = {
            :starting => StartingState.new(self),
            :story => StoryState.new(self),
            :scenario => ScenarioState.new(self),
            :given => GivenState.new(self),
            :when => WhenState.new(self),
            :then => ThenState.new(self),
          }
        end
        
        def transition_to_state(key)
          @state = @states[key]
        end
        
        def parse(lines)
          lines.reject! {|line| line == ""}
          until lines.empty?
            process_line(lines.shift)
          end
          @state.eof
        end
        
        MARKERS = {
          /^Story: / => :story,
          /^Scenario: / => :scenario,
          /^Given / => :given,
          /^When / => :event,
          /^Then / => :outcome,
          /^And / => :another
        }
        
        def process_line(line)
          line.strip!
          MARKERS.keys.each do |key|
            if line =~ key
              return @state.send(MARKERS[key], line)
            end
          end
          @state.other(line)
        end
        
        def transition_to(state)
          @state = state
        end
        
        def init_story(title)
          @current_story_lines.clear
          add_story_line(title)
        end
        
        def add_story_line(line)
          @current_story_lines << line
        end
        
        def create_story()
          unless @current_story_lines.empty?
            @story_part_factory.create_story(@current_story_lines[0].gsub("Story: ",""), @current_story_lines[1..-1].join("\n"))
            @current_story_lines.clear
          end
        end
        
        def create_scenario(title)
          @story_part_factory.create_scenario(title.gsub("Scenario: ",""))
        end
        
        def create_given(name)
          @story_part_factory.create_given(name)
        end
        
        def create_when(name)
          @story_part_factory.create_when(name)
        end
        
        def create_then(name)
          @story_part_factory.create_then(name)
        end
        
        class State
          def initialize(parser)
            @parser = parser
          end
          
          def story(line)
            @parser.init_story(line)
            @parser.transition_to_state(:story)
          end

          def scenario(line)
            @parser.create_scenario(line)
            @parser.transition_to_state(:scenario)
          end
          
          def eof
          end
          
        end
        
        class StartingState < State
          def initialize(parser)
            @parser = parser
          end
        end
        
        class StoryState < State
          def story(line)
            @parser.create_story
            @parser.add_story_line(line)
          end
          
          def scenario(line)
            @parser.create_story
            @parser.create_scenario(line)
            @parser.transition_to_state(:scenario)
          end
          
          def other(line)
            @parser.add_story_line(line)
          end
          
          def eof
            @parser.create_story
          end
          
        end

        class ScenarioState < State
          def given(line)
            @parser.create_given(line.gsub("Given ",""))
            @parser.transition_to_state(:given)
          end
        end
        
        class GivenState < State
          def another(line)
            @parser.create_given(line.gsub("And ",""))
          end
          
          def event(line)
            @parser.create_when(line.gsub("When ",""))
            @parser.transition_to_state(:when)
          end
        end
        
        class WhenState < State
          def another(line)
            @parser.create_when(line.gsub("And ",""))
          end

          def outcome(line)
            @parser.create_then(line.gsub("Then ",""))
            @parser.transition_to_state(:then)
          end
          
          def eof
          end
        end

        class ThenState < State
          def another(line)
            @parser.create_then(line.gsub("And ",""))
          end

          def eof
          end
        end

      end

    end
  end
end
