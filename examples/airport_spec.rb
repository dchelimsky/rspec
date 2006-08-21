require File.dirname(__FILE__) + '/../lib/spec'

class Airport
  def working?
    true
  end
  
  def need?(thing)
    false unless [:cables, :electricity].include? thing
  end
end

context "Airport at home" do
  setup do
    @airport = Airport.new
  end
  
  specify "should always work" do
    @airport.should_be_working
  end

  specify "not need cables" do
    @airport.should_not_need :cables
  end

  specify "not need electricity" do
    @airport.should_not_need :electricity
  end
  
  teardown do
    @airport = nil
  end
end
