class MockListener
  attr_reader :pass_name_received, :failure_name_received, :error_received

  def pass(context_name, spec_name)
    @pass_name_received = spec_name
  end
  
  def fail(context_name, spec_name, error)
    @failure_name_received = spec_name
    @error_received = error
  end
  
end