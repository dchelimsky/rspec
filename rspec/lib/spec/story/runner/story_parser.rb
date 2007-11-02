module Spec
  module Story
    module Runner
      
      class IllegalStepError < StandardError
        def initialize(state, event)
          super("Illegal attempt to create a #{event} after a #{state}")
        end
      end

      class StoryParser
        def initialize(story_mediator)
          @story_mediator = story_mediator
          @current_story_lines = []
          transition_to(:starting_state)
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
          /^And / => :one_more_of_the_same
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
        
        def init_story(title)
          @current_story_lines.clear
          add_story_line(title)
        end
        
        def add_story_line(line)
          @current_story_lines << line
        end
        
        def create_story()
          unless @current_story_lines.empty?
            @story_mediator.create_story(@current_story_lines[0].gsub("Story: ",""), @current_story_lines[1..-1].join("\n"))
            @current_story_lines.clear
          end
        end
        
        def create_scenario(title)
          @story_mediator.create_scenario(title.gsub("Scenario: ",""))
        end
        
        def create_given(name)
          @story_mediator.create_given(name)
        end
        
        def create_when(name)
          @story_mediator.create_when(name)
        end
        
        def create_then(name)
          @story_mediator.create_then(name)
        end

        def transition_to(key)
          @state = states[key]
        end
        
        def states
          @states ||= {
            :starting_state => StartingState.new(self),
            :story_state => StoryState.new(self),
            :scenario_state => ScenarioState.new(self),
            :given_state => GivenState.new(self),
            :when_state => WhenState.new(self),
            :then_state => ThenState.new(self)
          }
        end
        
        class State
          def initialize(parser)
            @parser = parser
          end
          
          def story(line)
            @parser.init_story(line)
            @parser.transition_to(:story_state)
          end

          def scenario(line)
            @parser.create_scenario(line)
            @parser.transition_to(:scenario_state)
          end

          def given(line)
            @parser.create_given(line.gsub("Given ",""))
            @parser.transition_to(:given_state)
          end
          
          def event(line)
            @parser.create_when(line.gsub("When ",""))
            @parser.transition_to(:when_state)
          end
          
          def outcome(line)
            @parser.create_then(line.gsub("Then ",""))
            @parser.transition_to(:then_state)
          end

          def eof
          end
          
          def other(line)
            # no-op - supports header text before the first story in a file
          end
        end
        
        class StartingState < State
          def initialize(parser)
            @parser = parser
          end
        end
        
        class StoryState < State
          def one_more_of_the_same(line)
            other(line)
          end

          def story(line)
            @parser.create_story
            @parser.add_story_line(line)
          end
          
          def scenario(line)
            @parser.create_story
            @parser.create_scenario(line)
            @parser.transition_to(:scenario_state)
          end
          
          def given(line)
            other(line)
          end
          
          def event(line)
            other(line)
          end
          
          def outcome(line)
            other(line)
          end
          
          def other(line)
            @parser.add_story_line(line)
          end
          
          def eof
            @parser.create_story
          end
        end

        class ScenarioState < State
          def one_more_of_the_same(line)
            raise IllegalStepError.new("Scenario","And")
          end

          def scenario(line)
            @parser.create_scenario(line)
          end
        end
        
        class GivenState < State
          def one_more_of_the_same(line)
            @parser.create_given(line.gsub("And ",""))
          end
          
          def given(line)
            @parser.create_given(line.gsub("Given ",""))
          end
        end
        
        class WhenState < State
          def one_more_of_the_same(line)
            @parser.create_when(line.gsub("And ",""))
          end

          def event(line)
            @parser.create_when(line.gsub("When ",""))
          end
        end

        class ThenState < State
          def one_more_of_the_same(line)
            @parser.create_then(line.gsub("And ",""))
          end

          def outcome(line)
            @parser.create_then(line.gsub("Then ",""))
          end
        end

      end
    end
  end
end
