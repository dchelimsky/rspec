class Test::Unit::TestResult
  remove_method :passed?
  def passed?
    return @failures.empty? && @errors.empty? && rspec_options.run_examples
  end
end