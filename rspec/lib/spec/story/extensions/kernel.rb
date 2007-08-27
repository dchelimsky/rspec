module Kernel
  def Story(title, narrative, params = {}, &body)
    ::Spec::Story::Runner.story_runner.Story(title, narrative, params, &body)
  end
end
