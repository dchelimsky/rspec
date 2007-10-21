# This is an experimental version - need to add this to the library w/ specs

module Spec
  module Story
    class PlainTextStoryRunner

      def initialize(story_file)
        @story_file = story_file
      end

      def run
        factory = Spec::Story::Runner::StoryPartFactory.new step_matchers
        parser = Spec::Story::Runner::StoryParser.new factory

        story_text = File.read(@story_file)
        parser.parse story_text.split("\n")

        story_runner = Spec::Story::Runner.story_runner
        factory.stories.each { |story| story_runner.instance_eval(&story) }
      end
  
      def step_matchers
        @step_matchers ||= Spec::Story::StepMatchers.new
        yield @step_matchers if block_given?
        @step_matchers
      end
  
    end
  end
end
