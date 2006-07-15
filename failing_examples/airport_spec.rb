require File.dirname(__FILE__) + '/../lib/spec'

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
    @airport.should_be.working
  end

  specify "should not need cables" do
    @airport.should_not_need :cables
  end

  specify "should not need electricity" do
    # This will fail...
    @airport.should_not_need :electricity
  end
  
  teardown do
    @airport = nil
  end

end
