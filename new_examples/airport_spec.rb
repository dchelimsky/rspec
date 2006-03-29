require File.dirname(__FILE__) + '/../lib/spec/new_runner/context'

class Airport
  def working?
    true
  end
  
  def need?(thing)
    thing != :cables
  end
end

context "Airport at home" do
  setup do
    @airport = Airport.new
  end
  
  specify "should always work" do
    @airport.should.be.working
  end

  specify "should not require cables" do
    @airport.should.not.need :cables
  end

  specify "should not require elictricity" do
    # This will fail...
    @airport.should.need :electricity
  end
  
  teardown do
    @airport = nil
  end

end
