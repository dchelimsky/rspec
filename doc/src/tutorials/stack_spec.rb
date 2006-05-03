require 'stack'

context "A new stack" do
  setup do
    @stack = Stack.new
  end
  specify "should be empty" do
    @stack.should_be_empty
  end
end