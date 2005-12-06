require 'spec'

class AddSpecification < Spec::Context

  def a_passing_spec
    true.should_equal true
  end
  
  def a_failing_spec
    true.should_equal false
  end
  
end

AddSpecification.add_specification('another_failing_spec') { false.should_equal true }
