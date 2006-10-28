module Kernel
  def context(name, opts={}, &block)
    opts[:spec_path] = caller(0)[1]
    context_runner.add_context(Spec::Rails::ContextFactory.create(name, opts, &block))
    context_runner.run(false) if context_runner.standalone
  end
end
