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
    context_runner.add_context(Spec::Rails::Runner::ContextFactory.create(name, opts, &block))
  end
  alias :describe :context
end
