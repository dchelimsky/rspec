class Test::Unit::RspecTestResult < Test::Unit::TestResult
  def passed?
    return super && ::Spec.run
  end
end