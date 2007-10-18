# This is the beginning of an experimental StoryParser based on conversations
# on the rspec list: http://rubyforge.org/pipermail/rspec-users/2007-October/003704.html

module Spec
  module Story
    module Runner

      class StoryParser
        attr_reader :story_part_factory, :current_story_lines
        def initialize(story_part_factory)
          @story_part_factory = story_part_factory
          @current_story_lines = []
          @state = StartingState.new(self)
        end
        
        def parse(lines)
          lines.reject! {|line| line == ""}
          until lines.empty?
            process_line(lines.shift)
          end
          @state.eof
        end
        
        def process_line(line)
          if line =~ /^Story: /
            @state.story(line)
          elsif line =~ /^Scenario: /
            @state.scenario(line)
          elsif line =~ /^Given /
            @state.given(line)
          elsif line =~ /^When /
            @state.event(line)
          elsif line =~ /^Then /
            @state.outcome(line)
          elsif line =~ /^And /
            @state.another(line)
          else
            @state.process_line(line)
          end
        end
        
        def transition_to(state)
          @state = state
        end
        
        def init_story(line)
          @current_story_lines.clear
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
        
        class State
          def story(line)
            @parser.init_story(line)
            @parser.transition_to(StoryState.new(@parser))
          end

          def scenario(line)
            @parser.create_scenario(line)
            @parser.transition_to(ScenarioState.new(@parser))
          end
          
          def eof
          end
          
        end
        
        class StartingState < State
          def initialize(parser)
            @parser = parser
          end
        end
        
        class StoryState
          def initialize(parser)
            @parser = parser
          end
          
          def story(line)
            @parser.create_story
            @parser.current_story_lines << line
          end
          
          def scenario(line)
            @parser.create_story
            @parser.create_scenario(line)
            @parser.transition_to(ScenarioState.new(@parser))
          end
          
          def process_line(line)
            @parser.current_story_lines << line
          end
          
          def eof
            @parser.create_story
          end
          
        end

        class ScenarioState < State
          def initialize(parser)
            @parser = parser
          end
                    
          def given(line)
            @parser.story_part_factory.create_given(line.gsub("Given ",""))
            @parser.transition_to(GivenState.new(@parser))
          end
        end
        
        class GivenState < State
          def initialize(parser)
            @parser = parser
          end
          
          def another(line)
            @parser.story_part_factory.create_given(line.gsub("And ",""))
            @parser.transition_to(GivenState.new(@parser))
          end
          
          def event(line)
            @parser.story_part_factory.create_when(line.gsub("When ",""))
            @parser.transition_to(WhenState.new(@parser))
          end
        end
        
        class WhenState
          def initialize(parser)
            @parser = parser
          end
          
          def another(line)
            @parser.story_part_factory.create_when(line.gsub("And ",""))
            @parser.transition_to(WhenState.new(@parser))
          end

          def outcome(line)
            @parser.story_part_factory.create_then(line.gsub("Then ",""))
            @parser.transition_to(ThenState.new(@parser))
          end
          
          def eof
          end
        end

        class ThenState
          def initialize(parser)
            @parser = parser
          end
          
          def another(line)
            @parser.story_part_factory.create_then(line.gsub("And ",""))
            @parser.transition_to(ThenState.new(@parser))
          end

          def eof
          end
        end

      end

    end
  end
end
