module Kernel
  def context(*args, &block)
    name = args.shift.to_s
    if !args.empty? && String === args.first
      name += args.shift
    end
    if !args.empty? && Hash === args.last
      opts = args.pop
    else
      opts = {}
    end
    opts[:spec_path] = caller(0)[1]
    behaviour_runner.add_behaviour(Spec::Rails::Runner::BehaviourFactory.create(name, opts, &block))
  end
  alias :describe :context
end
