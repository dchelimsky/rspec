require File.dirname(__FILE__) + '/../lib/spec'

class Airport
  def working?
    true
  end
  
  def need?(thing)
    thing != :cables
  end
end

class Spec::Runner::Context
  alias should specify
  alias must specify
  alias fact specify
end
module Kernel
  alias topic context
end

topic "Airport at home" do
  setup do
    @airport = Airport.new
  end
  
  fact "should always work" do
    @airport.should.be.working
  end

  must "not need cables" do
    @airport.should.not.need :cables
  end

  must "not need electricity" do
    # This will fail...
    @airport.should.not.need :electricity
  end
  
  teardown do
    @airport = nil
  end

end
