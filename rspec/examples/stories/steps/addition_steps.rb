class AdditionSteps < Spec::Story::StepGroup
  steps do |add|
    add.given("an addend of $addend") do |addend|
      @adder ||= Adder.new
      @adder << addend.to_i
    end
    add.when("the addends are added") { @sum = @adder.sum }
    add.then("the sum should be $sum") {|sum| @sum.should == sum.to_i }
  end
end
