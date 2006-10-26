module Kernel
  def context(name, opts={}, &block)
    spec_file = caller(0)[1]
    if (spec_file =~ /\/spec\/+views/) || (opts[:context_type] == :view)
      context_runner.add_context(Spec::Rails::ViewContext.new(name, &block))
    elsif (spec_file =~ /\/spec\/+controllers/)  || (opts[:context_type] == :controller)
      context_runner.add_context(Spec::Rails::ControllerContext.new(name, &block))
    elsif spec_file =~ (/\/spec\/+helpers/) || (opts[:context_type] == :helper)
      context_runner.add_context(Spec::Rails::HelperContext.new(name, &block))
    else
      context_runner.add_context(Spec::Rails::ModelContext.new(name, &block))
    end
    context_runner.run(false) if context_runner.standalone
  end
end
