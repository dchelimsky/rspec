class Test::Unit::UI::TestRunnerMediator
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
    behaviour_runner.finish
  end
end