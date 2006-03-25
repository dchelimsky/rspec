context "Airport at home" do

  setup do
    @airport = Airport.new("home")
    @airport.plug_in
  end
  
  specify "should always work" do
    @airport.should.be.working
  end

  specify "should not require cables" do
    @airport.should.not.require :cables
  end

end