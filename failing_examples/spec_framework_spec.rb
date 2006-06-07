require File.dirname(__FILE__) + '/../lib/spec'

class SpecFramework
  def intuitive?
    true
  end
  
  def adopted_quickly?
    false
  end
end

context "Spec framework" do

  setup do
    @spec_framework = SpecFramework.new
  end

  specify "should be adopted quickly" do
    #this will fail
    @spec_framework.should_be_adopted_quickly
  end
  
  specify "should be intuitive" do
    @spec_framework.should_be_intuitive
  end

end