module Spec
  module Story
    module Runner
      class PlainTextStoryRunner
        # You can initialize a PlainTextStoryRunner with the path to the
        # story file or a block, in which you can define the path using load.
        #
        # == Examples
        #   
        #   PlainTextStoryRunner.new('path/to/file')
        #
        #   PlainTextStoryRunner.new do |runner|
        #     runner.load 'path/to/file'
        #   end
        def initialize(path=nil)
          @story_file = path
          yield self if block_given?
        end
        
        def load(path)
          @story_file = path
        end
        
        def run
          raise "You must set a path to the file with the story. See the RDoc." if @story_file.nil?
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
