require File.dirname(__FILE__) + '/../lib/spec'

class BddFramework
  def intuitive?
    true
  end
  
  def adopted_quickly?
    true
  end
end

context "BDD framework" do

  setup do
    @bdd_framework = BddFramework.new
  end

  specify "should be adopted quickly" do
    @bdd_framework.should.be.adopted_quickly
  end
  
  specify "should be intuitive" do
    @bdd_framework.should.be.intuitive
  end

end