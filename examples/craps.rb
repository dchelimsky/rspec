class Craps

  def initialize(a_die, another_die)
    @die1 = a_die
    @die2 = another_die
  end
  
  def play
    total_roll = @die1.roll() + @die2.roll()
    return true if total_roll == 7
    return true if total_roll == 11
    false
  end
  
end
