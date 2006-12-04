require File.dirname(__FILE__) + '/../../../spec_helper.rb'
class SomethingExpected
  attr_accessor :some_value
end

context "should_change using (receiver, message)" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 5
  end

  specify "should not raise exception when the target is modified by the block" do
    lambda do
      lambda {@instance.some_value = 6}.should_change(@instance, :some_value)
    end.should_pass
  end

  specify "should raise exception when the target is not modified by the block" do
    lambda do
      lambda {}.should_change(@instance, :some_value)
    end.should_fail_with "some_value should have changed, but is still 5"
  end
end

context "should_change using { block }" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 5
  end

  specify "should not raise exception when the target is modified by the block" do
    lambda do
      lambda {@instance.some_value = 6}.should_change { @instance.some_value }
    end.should_pass
  end

  specify "should raise exception when the target is not modified by the block" do
    lambda do
      lambda {}.should_change{ @instance.some_value }
    end.should_fail_with "result should have changed, but is still 5"
  end
end

context "should_change.by using (receiver, message)" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 5
  end

  specify "should pass when attribute is changed by expected amount" do
    lambda do
      lambda { @instance.some_value += 1 }.should_change(@instance, :some_value).by(1)
    end.should_pass
  end

  specify "should fail when the attribute is changed by unexpected amount" do
    lambda do
      lambda { @instance.some_value += 2 }.should_change(@instance, :some_value).by(1)
    end.should_fail_with "some_value should have been changed by 1, but was changed by 2"
  end

  specify "should fail when the attribute is changed by unexpected amount in the opposite direction" do
    lambda do
      lambda { @instance.some_value -= 1 }.should_change(@instance, :some_value).by(1)
    end.should_fail_with "some_value should have been changed by 1, but was changed by -1"
  end
end

context "should_change.by using {block}" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 5
  end

  specify "should pass when attribute is changed by expected amount" do
    lambda do
      lambda { @instance.some_value += 1 }.should_change{@instance.some_value}.by(1)
    end.should_pass
  end

  specify "should fail when the attribute is changed by unexpected amount" do
    lambda do
      lambda { @instance.some_value += 2 }.should_change{@instance.some_value}.by(1)
    end.should_fail_with "result should have been changed by 1, but was changed by 2"
  end

  specify "should fail when the attribute is changed by unexpected amount in the opposite direction" do
    lambda do
      lambda { @instance.some_value -= 1 }.should_change{@instance.some_value}.by(1)
    end.should_fail_with "result should have been changed by 1, but was changed by -1"
  end
end

context "should_change.from using (receiver, message)" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 'string'
  end

  specify "should pass when attribute is == to expected value before executing block" do
    lambda do
      lambda { @instance.some_value = "astring" }.should_change(@instance, :some_value).from("string")
    end.should_pass
  end

  specify "should fail when attribute is not == to expected value before executing block" do
    lambda do
      lambda { @instance.some_value = "knot" }.should_change(@instance, :some_value).from("cat")
    end.should_fail_with "some_value should have initially been \"cat\", but was \"string\""
  end
end

context "should_change.from using {block}" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 'string'
  end

  specify "should pass when attribute is == to expected value before executing block" do
    lambda do
      lambda { @instance.some_value = "astring" }.should_change{@instance.some_value}.from("string")
    end.should_pass
  end

  specify "should fail when attribute is not == to expected value before executing block" do
    lambda do
      lambda { @instance.some_value = "knot" }.should_change{@instance.some_value}.from("cat")
    end.should_fail_with "result should have initially been \"cat\", but was \"string\""
  end
end

context "should_change.to(y) using {receiver, message}" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 'string'
  end
  
  specify "should pass when attribute is == to expected value after executing block" do
    lambda do
      lambda { @instance.some_value = "cat" }.should_change(@instance, :some_value).to("cat")
    end.should_pass
  end

  specify "should fail when attribute is not == to expected value after executing block" do
    lambda do
      lambda { @instance.some_value = "cat" }.should_change(@instance, :some_value).from("string").to("dog")
    end.should_fail_with "some_value should have been changed to \"dog\", but is now \"cat\""
  end
end

context "should_change.to(y) using {block}" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 'string'
  end
  
  specify "should pass when attribute is == to expected value after executing block" do
    lambda do
      lambda { @instance.some_value = "cat" }.should_change{@instance.some_value}.to("cat")
    end.should_pass
  end

  specify "should fail when attribute is not == to expected value after executing block" do
    lambda do
      lambda { @instance.some_value = "cat" }.should_change{@instance.some_value}.from("string").to("dog")
    end.should_fail_with "result should have been changed to \"dog\", but is now \"cat\""
  end
end

context "should_change.from(x).to(y) using (receiver, message)" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 'string'
  end
  
  specify "should pass when #to comes before #from" do
    lambda do
      lambda { @instance.some_value = "cat" }.should_change(@instance, :some_value).to("cat").from("string")
    end.should_pass
  end

  specify "should pass when #from comes before #to" do
    lambda do
      lambda { @instance.some_value = "cat" }.should_change(@instance, :some_value).from("string").to("cat")
    end.should_pass
  end
end

context "should_change.from(x).to(y) using {block}" do
  setup do
    @instance = SomethingExpected.new
    @instance.some_value = 'string'
  end
  
  specify "should pass when #to comes before #from" do
    lambda do
      lambda { @instance.some_value = "cat" }.should_change{@instance.some_value}.to("cat").from("string")
    end.should_pass
  end

  specify "should pass when #from comes before #to" do
    lambda do
      lambda { @instance.some_value = "cat" }.should_change{@instance.some_value}.from("string").to("cat")
    end.should_pass
  end
end
