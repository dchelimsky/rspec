# This is an experimental version - need to add this to the library w/ specs

module Spec
  module Story
    class PlainTextStoryRunner
      attr_reader :step_matchers

      def initialize(story_file)
        story(story_file)
      end

      def run
        factory = Spec::Story::Runner::StoryPartFactory.new step_matchers
        parser = Spec::Story::Runner::StoryParser.new factory

        story_text = File.read(@story_file)
        parser.parse story_text.split("\n")

        story_runner = Spec::Story::Runner.story_runner
        factory.stories.each { |s| story_runner.instance_eval &s }
      end
  
      def step(type, name, &block)
        step_matchers.create_matcher(type, name, &block)
      end
  
      def story(file)
        @story_file = file
      end

      def step_matchers
        $rspec_story_step_matchers ||= Spec::Story::StepMatchers.new
      end
  
    end
  end
end
