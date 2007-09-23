module Spec
  module Story
    module Extensions
      module Main
        def Story(title, narrative, params = {}, &body)
          ::Spec::Story::Runner.story_runner.Story(title, narrative, params, &body)
        end
      end
    end
  end
end

include Spec::Story::Extensions::Main