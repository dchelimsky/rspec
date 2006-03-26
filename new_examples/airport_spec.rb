require File.dirname(__FILE__) + '/../lib/spec/new_runner/context_runner'

class Airport
  def working?
    true
  end
  
  def require?(thing)
    thing != :cables
  end
end

context "Airport at home" do
  puts "I am now in the context of #{self}"
  
  setup do
    @airport = Airport.new
  end
  
  specify "should always work" do
    puts "And I am now in the context of #{self}"
    @airport.should.be.working
  end

  specify "should not require cables" do
    @airport.should.not.require :cables
  end

end