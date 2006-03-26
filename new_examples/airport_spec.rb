require File.dirname(__FILE__) + '/../lib/spec/runner/text_runner'

class Airport
  def working?
    true
  end
end

context "Airport at home" do
  puts "I am now #{self}"
  
  specify "should always work" do
    puts "And I am now #{self}"
    @airport.should.be.working
  end

  specify "should not require cables" do
    @airport.should.not.require :cables
  end

end