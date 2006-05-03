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
    @team.should_have(3).players
  end
  
  specify "should have no players" do
    @team.players.size.should.be 0
  end
  
end