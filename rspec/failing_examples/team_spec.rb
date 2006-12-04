require File.dirname(__FILE__) + '/spec_helper'


class Team
  attr_reader :players
  def initialize
    @players = Players.new
  end
end

class Players
  def initialize
    @players = []
  end
  def size
    @players.size
  end
  def include? player
    raise "player must be a string" unless player.is_a?(String)
    @players.include? player
  end
end

context "A new team" do
  
  setup do
    @team = Team.new
  end
  
  specify "should have 3 players (failing example)" do
    @team.should_have(3).players
  end
  
  specify "should include some player (failing example)" do
    @team.players.should_include("Some Player")
  end

  specify "should include 5 (failing example)" do
    @team.players.should_include(5)
  end
  
  specify "should have no players" do
    @team.should_have(:no).players
  end
  
end
