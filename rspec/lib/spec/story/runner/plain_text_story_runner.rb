module Spec
  module Story
    module Runner
      class PlainTextStoryRunner
        def step_matchers
          @step_matchers ||= StepMatchers.new
          yield @step_matchers if block_given?
          @step_matchers
        end
      end
    end
  end
end
