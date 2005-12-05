require 'spec'
require File.dirname(__FILE__) + '/craps'

class CrapsSpecification < Spec::Context

  def setup
    @die1 = mock "die1"
    @die2 = mock "die2"
    @game = Craps.new(@die1, @die2)
  end
  
  # coming out roll of 7
  
  def come_out_roll_of_1_6_wins
    _load_dice([1], [6])
    @game.play.should_be_true
  end

  def come_out_roll_of_2_5_wins
    _load_dice([2], [5])
    @game.play.should_be_true
  end

  def come_out_roll_of_3_4_wins
    _load_dice([3], [4])
    @game.play.should_be_true
  end

  def come_out_roll_of_4_3_wins
    _load_dice([4], [3])
    @game.play.should_be_true
  end

  def come_out_roll_of_5_2_wins
    _load_dice([5], [2])
    @game.play.should_be_true
  end  

  def come_out_roll_of_6_1_wins
    _load_dice([6], [1])
    @game.play.should_be_true
  end

  # coming out roll of 11
  
  def come_out_roll_of_5_6_wins
    _load_dice([5], [6])
    @game.play.should_be_true
  end

  def come_out_roll_of_6_5_wins
    _load_dice([6], [5])
    @game.play.should_be_true
  end
  
  # coming out roll of 2
  
  def come_out_roll_of_1_1_looses
    _load_dice([1], [1])
    @game.play.should_be_false
  end
  
  # coming out roll of 3
  
  def come_out_roll_of_1_2_looses
    _load_dice([1], [2])
    @game.play.should_be_false
  end

  def come_out_roll_of_2_1_looses
    _load_dice([2], [1])
    @game.play.should_be_false
  end

  # coming out roll of 12
  
  def come_out_roll_of_6_6_looses
    _load_dice([6], [6])
    @game.play.should_be_false
  end
  
  # loosing with a point
  
#  def second_roll_of_7_looses
#    _load_dice([2, 4], [2, 3])
#    @game.play.should_be_false
#  end
  
  # support

  def _load_dice(rolls1, rolls2)
    _load_die(@die1, rolls1)
    _load_die(@die2, rolls2)
  end
  
  def _load_die(die, rolls)
    rolls.each { |roll| die.should_receive(:roll).once.with_no_args.and_return(roll) }
  end
  
end

if __FILE__ == $0
  runner = Spec::TextRunner.new($stdout)
  runner.run(CrapsSpecification)
end
