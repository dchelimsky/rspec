require File.dirname(__FILE__) + '/../lib/spec'

context :inherited_context do
  setup do
    @inherited = "from super"
  end
end

context "Inheriting Context" => :inherited_context do

  setup do
    @local = "from local"
  end
  
  specify "should be inherit as well as local" do
    @inherited.should.equal "from super"
    @local.should.equal "from local"
  end

end