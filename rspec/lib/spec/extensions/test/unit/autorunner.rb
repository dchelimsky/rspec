class Test::Unit::AutoRunner
  class << self
    def new(*args, &blk)
      custom_runner = rspec_options.custom_runner
      if custom_runner
        custom_runner
      else
        super
      end
    end
  end

  remove_method :process_args
  def process_args(argv)
    true
  end
end
