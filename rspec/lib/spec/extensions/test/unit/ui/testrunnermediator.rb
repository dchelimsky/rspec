class Test::Unit::UI::TestRunnerMediator
  private
  remove_method :create_result
  # A factory method to create the result the mediator
  # should run with. Can be overridden by subclasses if
  # one wants to use a different result.
  def create_result
    return Test::Unit::RspecTestResult.new
  end
end