class Test::Unit::RspecTestResult < Test::Unit::TestResult
  def passed?
    return super && rspec_options.run_examples
  end
end