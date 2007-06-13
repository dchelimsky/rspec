require File.dirname(__FILE__) + '/../../spec_helper.rb'

class LiarLiarPantsOnFire
  def respond_to?(sym)
    true
  end
end
  
describe 'should_receive' do
  before(:each) do
    @liar = LiarLiarPantsOnFire.new
  end
  
  it "should work when object lies about responding to a method" do
    @liar.should_receive(:something=)
    @liar.something = "value"
  end

end
