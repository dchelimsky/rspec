class SpecMatcher

  def initialize(context_and_or_spec_name, context_name)
    @context_name = context_name
    @name_to_match = context_and_or_spec_name
  end
  
  def matches? spec
    if matches_context?
      if matches_spec?(spec) or context_only?
        return true
      end
    end
    if matches_spec? spec
      if spec_only? spec
        return true
      end
    end
  end
  
  private
  
  def spec_only? spec
    @name_to_match == spec
  end
  
  def context_only?
    @name_to_match == @context_name
  end
  
  def matches_context?
    @name_to_match =~ /^#{@context_name}\b/
  end
  
  def matches_spec? spec
    @name_to_match =~ /\b#{spec}$/
  end
  
end
