class Test::Unit::UI::TestRunnerMediator
  class << self
    def rspec_options_list
      @rspec_options_list ||= []
    end

    def rspec_options
      rspec_options_list.last || super
    end

    def current_rspec_options(options)
      rspec_options_list << options
      return_value = nil
      begin
        return_value = yield
      ensure
        rspec_options_list.pop
      end
      return_value
    end
  end
  original_verbose = $VERBOSE
  $VERBOSE = nil
  begin
    def initialize(suite)
      @suite = suite
      unless self.class.rspec_options.custom_runner?
        add_listener(STARTED, &method(:rspec_prepare))
        add_listener(FINISHED, &method(:rspec_finished))
      end
    end
  ensure
    $VERBOSE = original_verbose
  end

  protected
  def rspec_prepare(time)
    self.class.rspec_options.prepare
  end

  def rspec_finished(time)
    self.class.rspec_options.finish
  end
end