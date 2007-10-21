# This is the beginning of an experimental StoryParser based on conversations
# on the rspec list: http://rubyforge.org/pipermail/rspec-users/2007-October/003704.html

module Spec
  module Story
    module Runner
      
      class IllegalStepError < StandardError
        def initialize(state, event)
          super("Illegal attempt to create a #{event} after a #{state}")
        end
      end

      class StoryParser
        def initialize(story_part_factory)
          @story_part_factory = story_part_factory
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
            raise IllegalStepError.new("Story","Given")
          end
          
          def event(line)
            raise IllegalStepError.new("Story","When")
          end
          
          def outcome(line)
            raise IllegalStepError.new("Story","Then")
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
            @parser.transition_to(:given_state)
          end
        end
        
        class GivenState < State
          def one_more_of_the_same(line)
            @parser.create_given(line.gsub("And ",""))
          end
          
          def event(line)
            @parser.create_when(line.gsub("When ",""))
            @parser.transition_to(:when_state)
          end
        end
        
        class WhenState < State
          def one_more_of_the_same(line)
            @parser.create_when(line.gsub("And ",""))
          end

          def outcome(line)
            @parser.create_then(line.gsub("Then ",""))
            @parser.transition_to(:then_state)
          end
        end

        class ThenState < State
          def one_more_of_the_same(line)
            @parser.create_then(line.gsub("And ",""))
          end
        end

      end

    end
  end
end
