module Kernel
  def describe(*args, &block)
    args.last.is_a?(Hash) ? args.last[:spec_path] = caller(0)[1] : args << {:spec_path => caller(0)[1]}
    behaviour_runner.add_behaviour(Spec::Rails::Runner::BehaviourFactory.create(*args, &block))
  end
  alias :context :describe
end
