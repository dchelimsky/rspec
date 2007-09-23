class Test::Unit::TestResult
  def add_example_failure(example_run_proxy)
    @failures << example_run_proxy
  end
end