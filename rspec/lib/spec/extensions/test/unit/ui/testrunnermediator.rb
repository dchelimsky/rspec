class Test::Unit::UI::TestRunnerMediator
  class << self
    def behaviour_runners
      @behaviour_runners ||= []
    end

    def behaviour_runner
      behaviour_runners.last || super
    end

    def current_behaviour_runner(runner)
      behaviour_runners << runner
      return_value = nil
      begin
        return_value = yield
      ensure
        behaviour_runners.pop
      end
      return_value
    end
  end
  original_verbose = $VERBOSE
  $VERBOSE = nil
  begin
    def initialize(suite)
      @suite = suite
      add_listener(FINISHED, &method(:rspec_finished))
    end
  ensure
    $VERBOSE = original_verbose
  end

  protected
  def rspec_finished(time)
    self.class.behaviour_runner.finish
  end
end