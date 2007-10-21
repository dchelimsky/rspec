class CelebrationSteps < Spec::Story::StepMatchers
  def initialize
    super do |add|
      add.then("the corks should be popped") {}
    end
  end
end
