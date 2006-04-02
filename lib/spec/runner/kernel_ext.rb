module Kernel
  def context(name, &block)
    Spec::Runner::Context.new(name, &block) unless $generating_docs
    Spec::Runner::DocumentationContext.new(name, &block) if $generating_docs
  end
end
