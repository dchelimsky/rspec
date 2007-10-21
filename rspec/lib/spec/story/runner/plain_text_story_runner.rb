module Spec
  module Story
    module Runner
      class PlainTextStoryRunner
        def initialize(path)
          @story_file = path
        end
        
        def run
          mediator = Spec::Story::Runner::StoryMediator.new step_matchers, Spec::Story::Runner.story_runner
          parser = Spec::Story::Runner::StoryParser.new mediator

          story_text = File.read(@story_file)          
          parser.parse(story_text.split("\n"))

          mediator.run_stories
        end
        
        def step_matchers
          @step_matchers ||= Spec::Story::StepMatchers.new
          yield @step_matchers if block_given?
          @step_matchers
        end
      end
    end
  end
end
