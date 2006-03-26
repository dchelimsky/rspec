require File.dirname(__FILE__) + '/../lib/spec/new_runner/context'

class SpecFramework
  def intuitive?
    true
  end
  
  def adopted_quickly
    true
  end
end

context "Spec framework" do
  
  setup do
    @spec_framework = SpecFramework.new
  end
  
  specify "should be intuitive" do
    @spec_framework.should.be.intuitive
  end

  specify "should be adopted quickly" do
    @spec_framework.should.be.adopted_quickly
  end

end