module Kernel
  alias_method :original_describe, :describe
  def describe(*args, &block)
    args << {} unless Hash === args.last
    args.last[:spec_path] = caller(0)[1]
    original_describe(*args, &block)
  end
end
