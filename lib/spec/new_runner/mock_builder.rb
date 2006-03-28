class MockBuilder
  attr_reader :context_name_received, :spec_name_received, :failure_name_received, :error_received

  def add_context_name(name)
    @context_name_received = name
  end

  def add_spec_name(name)
    @spec_name_received = name
  end
  
  def pass(name)
    @pass
  end
  
  def fail(name, error)
    @failure_name_received = name
    @error_received = error
  end
  
end