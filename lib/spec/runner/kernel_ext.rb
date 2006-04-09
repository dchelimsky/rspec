module Kernel
  def context(name, &block)
    Spec::Runner::Context.new(name, &block)
  end
end
