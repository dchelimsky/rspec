require File.dirname(__FILE__) + '/../lib/spec'

class Team
  attr_reader :players
  def initialize
    @players = []
  end
end

context "A new team" do
  
  setup do
    @team = Team.new
  end
  
  specify "should have 3 players (failing example)" do
    @team.should.have(3).players
  end
  
  specify "should have 1 player (another failing example)" do
    @team.players.size.should.be 1
  end
  
end