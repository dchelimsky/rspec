require File.dirname(__FILE__) + '/../lib/spec'

class Team
  attr_reader :players
  def initialize
    @players = Players.new
  end
end

class Players
  def size
    0
  end
end

context "A new team" do
  
  setup do
    @team = Team.new
  end
  
  specify "should have 3 players (failing example)" do
    @team.should.have(3).players
  end
  
  specify "should have 1 player (failing example)" do
    @team.players.size.should.be 1
  end
  
end